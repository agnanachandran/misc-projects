#include <iostream>
#include <vector>
#include <set>

using namespace std;

struct Point {
    Point(int x, int y) : _x(x), _y(y) {}
    int _x;
    int _y;
};

struct Node {
    Node(Point p) : data(p), left(NULL), right(NULL) {}
    Point data;
    Node *left;
    Node *right;
};

bool lessThanX(const Point &a, const Point &b) { return a._x < b._x; }
bool lessThanY(const Point &a, const Point &b) { return a._y < b._y; }

struct point_x_le
{
    point_x_le(int m) : _m(m) {}
    int _m;
    bool operator()(const Point &p) {
        return p._x <= _m;
    }
};

struct point_x_ge
{
    point_x_ge(int m) : _m(m) {}
    int _m;
    bool operator()(const Point &p) {
        return p._x >= _m;
    }
};

struct point_y_le
{
    point_y_le(int m) : _m(m) {}
    int _m;
    bool operator()(const Point &p) {
        return p._y <= _m;
    }
};

struct point_y_ge
{
    point_y_ge(int m) : _m(m) {}
    int _m;
    bool operator()(const Point &p) {
        return p._y >= _m;
    }
};

void traverseTree(Node * &root) {
    if (root != NULL) {
        traverseTree(root->left);
        cout << root->data._x << " " << root->data._y << endl;
        traverseTree(root->right);
    }
}

Node *createTree(const vector<Point> allPoints, vector<Point> pointsByX, vector<Point> pointsByY, bool isHorizontalCut) {
    if (allPoints.size() == 0) { return NULL; }
    if (allPoints.size() == 1) { return new Node(allPoints.front()); }
    
    int mid = allPoints.size()/2;
    
    Point midPoint = allPoints.at(mid);
    
    Node *root = new Node(midPoint);
    
    if (isHorizontalCut) {
        vector<Point> bottomPoints;
        vector<Point> topPoints;
        for (vector<Point>::iterator it = pointsByX.begin(); it != pointsByX.end(); ++it) {
            if ((*it)._y > midPoint._y) {
                topPoints.push_back(*it); // should be top
            } else if ((*it)._y < midPoint._y) {
                bottomPoints.push_back(*it);
            }
        }
        
        vector<Point> bottomXPoints(pointsByX.begin(), std::remove_if(pointsByX.begin(), pointsByX.end(), point_y_ge(midPoint._y)));
        vector<Point> bottomYPoints(pointsByY.begin(), std::remove_if(pointsByY.begin(), pointsByY.end(), point_y_ge(midPoint._y)));
        root->left = createTree(bottomPoints, bottomXPoints, bottomYPoints, !isHorizontalCut);
        
        vector<Point> topXPoints(pointsByX.begin(), std::remove_if(pointsByX.begin(), pointsByX.end(), point_y_le(midPoint._y)));
        vector<Point> topYPoints(pointsByY.begin(), std::remove_if(pointsByY.begin(), pointsByY.end(), point_y_le(midPoint._y)));
        root->right = createTree(topPoints, topXPoints, topYPoints, !isHorizontalCut);
    } else {
        vector<Point> leftPoints;
        vector<Point> rightPoints;
        
        for (vector<Point>::iterator it = pointsByY.begin(); it != pointsByY.end(); ++it) {
            if ((*it)._x > midPoint._x) {
                rightPoints.push_back(*it);
            } else if ((*it)._x < midPoint._x) {
                leftPoints.push_back(*it);
            }
        }
        
        vector<Point> leftXPoints(pointsByX.begin(), std::remove_if(pointsByX.begin(), pointsByX.end(), point_x_ge(midPoint._x)));
        vector<Point> leftYPoints(pointsByY.begin(), std::remove_if(pointsByY.begin(), pointsByY.end(), point_x_ge(midPoint._x)));
        root->left = createTree(leftPoints, leftXPoints, leftYPoints, !isHorizontalCut);
        
        vector<Point> rightXPoints(pointsByX.begin(), std::remove_if(pointsByX.begin(), pointsByX.end(), point_x_le(midPoint._x)));
        vector<Point> rightYPoints(pointsByY.begin(), std::remove_if(pointsByY.begin(), pointsByY.end(), point_x_le(midPoint._x)));
        root->right = createTree(rightPoints, rightXPoints, rightYPoints, !isHorizontalCut);
    }
    
    return root;
}

int main(int argc, char *argv[])
{
    int numPoints;
    cin >> numPoints;
    
    // exit early if 'invalid' input/no points to process
    if (numPoints <= 0) return 0;
    
    vector<Point> points;
    
    for (int i = 0; i < numPoints; i++) {
        int x;
        int y;
        cin >> x;
        cin >> y;
        points.push_back(Point(x,y));
    }
    
    // copy points and sort by x co-ord
    vector<Point> pointsByX = points;
    sort(pointsByX.begin(), pointsByX.end(), lessThanX);
    
    // copy points and sort by y co-ord
    vector<Point> pointsByY = points;
    sort(pointsByY.begin(), pointsByY.end(), lessThanY);
    
    // Start building tree
    
    Node *root = createTree(pointsByX, pointsByX, pointsByY, false);
    
    traverseTree(root);
    
    return 0;
}