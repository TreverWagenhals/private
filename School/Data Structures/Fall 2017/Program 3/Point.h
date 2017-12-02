#ifndef POINT_H
#define POINT_H

// Represents the location of a point in Cartesian coordinates
class Point
{
public:
	// Default constructor
	Point () : defined(false) {}
	// Explicit constructor (should never be used since this class is only
	// in a struct that uses the default constructor)
	Point (double xVal, double yVal) : x(xVal), y(yVal), defined(true) {}
	
	// Accessors
	double X() const {return x;}
	double Y() const {return y;}
	bool Defined() const {return defined;}
	
	// Mutators
	void Set(double xVal, double yVal);
	
	// Length of a line from the calling point to pt2
	double Length(Point pt2);
	
	// Input-Output
	void Get(std::istream &is);
	void Show(std::ostream &os);
	
private:
	double x;			// x coordinate of point
	double y;			// y coordinate of point
	bool defined;		// flag to define whether coordinate point is valid
};

#endif
