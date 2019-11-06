new_cpp_cmake_project () {

    local name=$1
    local dir=${2:-.}

    if [ ! -d "$dir" ]; then
	printf "directory %s doesn't exist!\n" $dir
	return 1
    fi

    if [ -d "${dir}/${name}" ]; then
	printf "project %s already exists under %s\n" $name $(realpath $curr_dir/$dir)
	return 2
    fi


    set -e
    curr_dir=$(pwd)
    temp_dir=$(mktemp -d -t cpp_cmake-XXXXXXXXXX)

    printf "<<<<<< cloning project template ...\n"
    cd $temp_dir
    git clone git@github.com:JiaHaoo/cpp_cmake.git
    cd cpp_cmake
    ./name_your_project.sh $name
    rm ./name_your_project.sh

    printf "\n<<<<<< initializing git ...\n"
    rm -rf .git
    git init
    git add -A
    git commit -m 'created a cpp project with cmake'

    printf "\n<<<<<< moving project to given directory: $(realpath $curr_dir/$dir) ...\n"
    cd $curr_dir
    mv $temp_dir/cpp_cmake $dir/$name
    rmdir $temp_dir

    set +e

    printf "<<<<<< successfully created project %s under %s ...\n" $name $(realpath $dir)
}
