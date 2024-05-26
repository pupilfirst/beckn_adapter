# README

## Setup

Todo: add more details
Follow standard rails setup guidelines.

## Spec Question

- who is the creator? In terms of a course, it will have multiple authors, should I default it to the school?

### Implementation Restrictions

- For schools to be live on the BPP, its id must be present in the `BECKN_ENABLED_SCHOOL_IDS` environment variable.
- The courses needs to be live and `public_signup` should enabled for the course to be live on the BPP.
- The student will be _onboarded_ to `default cohort` set for the course if one is not provided else we will onboard to the first cohort that is live for the course. (Check `Course.beckn_cohort` method)
