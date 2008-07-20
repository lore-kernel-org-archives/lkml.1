Return-Path: <linux-kernel-owner+w=401wt.eu-S1758007AbYGTPQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758007AbYGTPQQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 11:16:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754250AbYGTPP6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 11:15:58 -0400
Received: from mx-out.forthnet.gr ([193.92.150.104]:53378 "EHLO
	mx-out.forthnet.gr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753364AbYGTPP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 11:15:57 -0400
X-Greylist: delayed 1308 seconds by postgrey-1.27 at vger.kernel.org; Sun, 20 Jul 2008 11:15:56 EDT
Authentication-Results: MX-IN-02.forthnet.gr smtp.mail=v13@v13.gr; spf=neutral
Authentication-Results: MX-IN-02.forthnet.gr header.from=v13@v13.gr; sender-id=neutral
From: Stefanos Harhalakis <v13@v13.gr>
To: Rene Herman <rene.herman@keyaccess.nl>
Subject: Re: From 2.4 to 2.6 to 2.7?
Date: Sun, 20 Jul 2008 17:53:47 +0300
User-Agent: KMail/1.9.9
Cc: Craig Milo Rogers <rogers@isi.edu>, Jan Engelhardt <jengelh@medozas.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Stoyan Gaydarov <stoyboyker@gmail.com>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, gorcunov@gmail.com,
       akpm@linux-foundation.org, mingo@elte.hu
References: <6d291e080807141910m573b29b2t753ea7c4db09902d@mail.gmail.com> <20080719204933.GE18350@isi.edu> <4882F886.7060507@keyaccess.nl>
In-Reply-To: <4882F886.7060507@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-7"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807201753.48252.v13@v13.gr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 20 July 2008, Rene Herman wrote:
> On 19-07-08 22:49, Craig Milo Rogers wrote:
> > On 08.07.19, Rene Herman wrote:
> >> Really, find me a single Linux developer who wouldn't try just a little
> >> bit harder for a big 3.0 release. This is still a community, not yet a
> >> boring office schedule...
> >
> > 	I'm afraid that the allure of 3.0 would mean that everyone
> > would want to get their shiny new subsystem/scheduler
> > rewrite/bootstrap file format change/whatever incorporated into it,
> > resulting in a protracted integration period and an unstable system.
> > According to this line of thought, Linus should simply announce
> > version 3.0 with no forewarning...
>
> Or better yet, we'd have 342 -rc's and a REALLY big party when 3.0
> finally hits the streets.

I suggest that major and minor versions follow some milestones (as suggested 
to a message that I cannot reply directly). For example:

Starting from 'today', mark all open bugs and change version to 2.7 when all 
those bugs are closed. Then mark the open bugs of that time and change to 2.8 
when those bugs are fixed. Repeat as needed.

Set a 'target'/goal and change version to 3.0 whenever worldwide linux 
server/desktop percentage reaches XX%. (Of course this may happen before 
changing to 2.7 but this is not a bad thing (tm)). Then set another target 
(that may not be related to linux adoption) etc, etc...

This will keep the current versioning scheme, set some common goals for all 
developers, add more meaning into trying to fix bugs and prevent the world
from experiencing large linux version numbers.

As a side-effect, setting targets like those may make the whole community 
cooperate even more/better by having common long-term goals.

...

p.s You could also keep the X.Y.Z notation and change the major version
number whenever the way of versioning changes (and the current one is
actually version 2) :P
