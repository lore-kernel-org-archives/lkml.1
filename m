Return-Path: <linux-kernel-owner+w=401wt.eu-S1759044AbXG1Kkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759044AbXG1Kkx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 06:40:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754128AbXG1Kkp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 06:40:45 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:4221 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753973AbXG1Kko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 06:40:44 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: ck@vds.kolivas.org
Subject: Re: [ck] Re: Linus 2.6.23-rc1
Date: Sat, 28 Jul 2007 12:40:41 +0200
User-Agent: KMail/1.9.7
Cc: "Matthew Hawkins" <darthmdh@gmail.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       Kasper Sandberg <lkml@metanurb.dk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org> <alpine.LFD.0.999.0707271922050.3442@woody.linux-foundation.org> <b21f8390707280036m6781856ckb64b5f10d2295fa5@mail.gmail.com> (sfid-20070728_101016_101479_8E8AB210)
In-Reply-To: <b21f8390707280036m6781856ckb64b5f10d2295fa5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707281240.42308.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag 28 Juli 2007 schrieb Matthew Hawkins:
> On 7/28/07, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > People who think SD was "perfect" were simply ignoring reality.
> > Sadly, that seemed to include Con too, which was one of the main
> > reasons that I never ended entertaining the notion of merging SD for
> > very long at all: Con ended up arguing against people who reported
> > problems, rather than trying to work with them.
>
> Not even Con thought SD was perfect, so this is being more than a
> little dishonest.
> One of his parting comments on the ck list was a list of things that
> could be fixed/improved.
[...]
> I'm sorry you in particular haven't been able to have the same
> experience with Con as so many others have, especially considering who
> you are and the weight your words have.  You've lost a really great
> asset and aren't even aware of it.  That's really sad for everyone.
>
> (fwiw the -ck list did a lot of the testing for CFS recently, and over
> the years various other things too.  Generally a good bunch of folks
> keen to try anything to make their Linux experience better.  And
> definitely devoid of these petty politics and egos that are plagueing
> other Linux-related lists.  You've not only lost Con, but perhaps one
> of the better testbeds also).

I fully agree to this. Being part of the ck mailing list community was fun 
and I really appreciate the friendly and supporting tone here. From the 
mails I ever read from the LKML - I do not read it regularily at all - I 
got the impression that its members can learn *a lot* from the ck mailing 
list community. And also from the TuxOnNice mailing list community.

For example on how to encourage users to send in their feedback and test 
kernel subsystems. And from what I heard again and again its exactly 
testing that is lacking to a great degree.

Actually even CFS was helped by the ck mailinglist community.

The tone on the ck mailinglist community encouraged me to compile kernel 
patches, try out latest ck patchsets and then when CFS could not do the 
same smooth music playback on my Amarok machine than SD try out a ton of 
patches from Ingo Molnar to get those regressions (compared to SD) fixed.

But all the times I stayed away from LKML and still do not feel that much 
motivation to read in it regularily. Actually my own perceptions matches  
what Con said in his goodbye interview[1]: It *scares* me away. Its this 
elitist "I know it better than you and what do you want anyway" that in 
my eyes demotivate a lot of users to bring in their feedback.

There are just about 9000 bugs in the kernel bugtracker and about 150000 
bugs in the KDE bugtracker. Granted KDE bugtracker includes a lot of 
applications, but still I think the number of bug reports in the kernel 
bugtracker is ridicolously low. And I think thats because many users 
don't bother to report bugs upstream for the Linux kernel, not because 
that those bugs aren't there.

I hope that the ck mailing list community will continue to be active and 
possibly try to get swap prefetch and some other goodies of the ck 
patchset into mainline. And I think it would also be a good idea for ck 
mailing list community to report desktop related issues in the kernel 
bugtracker. I think I will take the courage next time I find anything, 
and report it straight there.

Maybe some talented developer will take up on the ck patchset and maybe 
once in a while he will find a friendlier environment to merge in parts 
of the ck patchset that should have gone mainline years ago. 

Maybe at least that is learned out of what happened here. I do think that 
a *friendly* tone matters and makes a difference. Being friendly and 
honestly saying the own oppinion on technical matters simply do not have 
to contradict themselves. Still I got the impression that some do 
think "Either I say it harsh and true or I be friendly and lie what 
goes".

[1] http://apcmag.com/6735/interview_con_kolivas

Regards,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
