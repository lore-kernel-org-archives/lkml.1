Return-Path: <linux-kernel-owner+w=401wt.eu-S1758776AbXG1Xlf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758776AbXG1Xlf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 19:41:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755095AbXG1Xl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 19:41:29 -0400
Received: from hades.rz.tu-clausthal.de ([139.174.2.20]:64607 "EHLO
	hades.rz.tu-clausthal.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbXG1Xl2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 19:41:28 -0400
From: Volker Armin Hemmann <volker.armin.hemmann@tu-clausthal.de>
To: linux-kernel@vger.kernel.org
Subject: Re: Linus 2.6.23-rc1
Date: Sun, 29 Jul 2007 01:41:19 +0200
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200707290141.19790.volker.armin.hemmann@tu-clausthal.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I never tried Con's patchset, for two reasons:
I tried his 2.4 patches ones, and I never saw any improvements. So when people 
were reporting huge improvements with his SD scheduler, I compared that with 
the reports of huge improvements with his 2.4 kernel patches.
...
The second: too many patches. I only would have tried one or two, but the 
ck-patchset is a lot bigger.. and I am a little bit uneasy about that.

But I tried a lot of Ingo's cfs patches - and it was a very pleasant 
experience. Ingo reacted very fast on my feedback and when I hit a problem he 
really tried to find the cause and solve it - and it always was one patch, so 
I felt a lot less scared ;)

My usual workload is very 'usual'. KDE desktop, kmail, konqueror, sometimes 
xine or amarok providing some background noise while typing away in kate, 
triplea, wesnoth or some other game when I need to 'rest' for a while. A lot 
of compiling in the background, because I am one of these gentoo users.

With cfs the experience was much more pleasant than with the 'old' scheduler. 
Compiling did not hurt as much as usual anymore - the only thing that hurts 
is swap.... 

But there is another thing I do regularly: I play ut2004. Not every single 
day, but sometimes several times a day. 20minutes of mayhem and then back to 
the desktop.

And I do not see any problems with cfs and ut2004. The maximum FPS are indeed 
a little bit lower (and you can argue that this really is not important if 
the pre-game FPS in a level looking down on the floor go down from 390 to 
380FPS), but the minimum FPS went up!

In scenes when my system is fighting hard to provide the FPS, when the action 
is high (like when fighting with half a douzend bots at a power node, while 
some other bots are shooting into the mess) CFS is much better than the old 
scheduler. It is a big difference if you get 6-10FPS or 15-25.
(I am playing with maximum 'beautifullness' - I would be able to get a lot 
more FPS, if I wanted, but I want a nice scenery and maximum visual 
effects ...)

>From my point of view 3D is a lot better with cfs. 

Now the question for all the people who are bashing cfs for its bad 3d 
performance: what am I doing wrong?

Glück Auf,
Volker

