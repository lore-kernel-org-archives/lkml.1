Return-Path: <linux-kernel-owner+w=401wt.eu-S1754658AbXKDRaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658AbXKDRaj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 12:30:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752028AbXKDRab
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 12:30:31 -0500
Received: from main.gmane.org ([80.91.229.2]:39046 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751037AbXKDRaa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 12:30:30 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Remigiusz Modrzejewski <lkml.only@maxnet.org.pl>
Subject: Re: Policy on dual licensing?
Date: Sun, 4 Nov 2007 17:30:15 +0000 (UTC)
Message-ID: <slrnfis0mv.cms.lkml.only@localhost.localdomain>
References: <slrnfiopoa.9cu.lkml.only@localhost.localdomain> <20071104000443.GB30710@thunk.org>
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: host-ip38-174.crowley.pl
X-Posting-License: http://ppl.7thguard.net/PPL
X-Homesite: http://lrem.net/
User-Agent: slrn/0.9.8.1 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
>> There are over four hundred C source files that mention BSD, but only 
>> a hundred of them is dual licensed. Of course not all mentions of BSD
>> mean the file is derived from it, as well as not each such licensed file
>> must use the acronym.  No matter what the scale really is, the problem
>> exists.
>
> First of all, just because it mentioned BSD doesn't necessarily mean
> that it came from BSD.  For example, I wrote the /dev/random driver
> spceifically from Linux, but dual licensed it because I wanted the BSD
> camps to pick it up.  Secondly, you're presupposing that it is a
> *problem*.  There are those who believe that there is nothing wrong,
> either morally, ethically, or legally, with taking BSD code, and not
> dual-licesing it when adding GPL-specific additions.  You are begging
> the question by just asserting that it is a _problem_.  Some people
> view the GPLv2 license as a feature, not a bug.  

All of my publicly released code is GPLv2. I just like it, but I don't
like the idea of taking someones else code and prohibiting him from
back-porting changes. On the other hand, you're probably just right,
I could've been decepted about the scale by the whining.

>>  However, this should minimize such cases 
>> and, hopefully, satisfy the claims about Linux maintainers not doing 
>> all that they could to make the world a better place.
>
> Actually, again, you're begging the question.  I have no doubt that
> people who write code under a BSD, CDDL, or GPL license all believe
> they are making the world a better place in their own way.  For you to
> say that Linux maintainers who don't try to get more drivers dual
> licensed === not making the world a better place is just as unfair as

This is not my claim. I've just got an idea how to prevent future flame
wars, bad press and other disturbances created by such claims. For me,
the idea looks quite good as it does not cost really much and is the
only thing that we can really do. If even this little additional strain
on the maintainers seems too much, considering the scale of the problem
really is minute, then just forget about the whole thing.

But, on the end of the day, the whole thing remains a problem in my
eyes. BSD folks have explicitly agreed companies/organisations to not
give back. These have divided into those who do give back, and those who
don't. Having Linux community in the second category feels not so good.
However, the fact that in most(?) cases it is not so is relaxing.

-- 
Remigiusz 'lRem' Modrzejewski
Contact: http://lrem.net/pages/view/about
Feel free to correct my English.

