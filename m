Return-Path: <linux-kernel-owner+w=401wt.eu-S1751820AbYKFTrj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751820AbYKFTrj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 14:47:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751042AbYKFTra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 14:47:30 -0500
Received: from hope.ime.usp.br ([143.107.45.8]:56385 "HELO hope.ime.usp.br"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750909AbYKFTr3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 14:47:29 -0500
Date: Thu, 6 Nov 2008 17:47:24 -0200
From: =?iso-8859-1?Q?Rog=E9rio?= Brito <rbrito@ime.usp.br>
To: Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
       yakui.zhao@intel.com
Cc: bugme-daemon@bugzilla.kernel.org
Subject: Re: [Bugme-new] [Bug 11717] New: Pressing suspend button suspends, but does not wakes up
Message-ID: <20081106194724.GB15366@ime.usp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, all.

I have already filed a bug on bugzilla, but it seems that that hasn't
generated too much attention and I am willing to do as many tests as
possible to get things working fine here.

Here is my first post to bugzilla, just to give you some context:

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Latest working kernel version: none
Earliest failing kernel version: 2.6.24
Distribution: Ubuntu Intrepid alphas
Hardware Environment: Itautec Note N8320
Software Environment: Ubuntu userland
Problem Description:

I just bougth a small notebook that is based on the ICH8 chipset with a
Core 2 Duo T7250 processor and it came bundled with Windows Vista.

Under Windows Vista (now, uninstalled), when I press the suspend button, it
suspends the machine and when I press the suspend button a second time, the
machine wakes up as expected.

Unfortunately, with kernels available in Ubuntu (hardy, intrepid), if I
press the suspend button, the machine will go to suspend mode, but if I
press the button again, the machine powers off.

Despite the fact that I'm using a range of Ubuntu kernels, I can install
the stock kernel.org (actually, I plan on installing a vanilla Debian with
my own compiled kernel) and I can provide as much information is needed
(logs, etc).

Steps to reproduce: Press the suspend button. Press the suspend button
again.


Thanks in advance, Rogério Brito.
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

It is still not working with Ubuntu's 2.6.27 kernel.

Actually, things are a bit worse: I can't hibernate the machine as well
(it's not only suspend that doesn't work; hibernate also does not).

It is based on a plain ICH8 chipset.

I can put even a video of how it "works" :-( on the web. Just please let me
know and I will do my best.

Just for the record, I'm not one of those bug reporters that disappear. I'm
willing to work hard to get things working, testing anything that I can.

Oh, BTW, I posted a video of the machine (not) working at
<http://www.ime.usp.br/~rbrito/linux/notebook.mp4>, in case you're
interested. If the resolution is not enough, please let me know and I try
to get a better video.

Also, I have posted a lot of information in bugzilla, but I am willing to
post them again, perhaps with different command line switches which might
help.


Regards, Rogério Brito.

-- 
Rogério Brito : rbrito@{mackenzie,ime.usp}.br : GPG key 1024D/7C2CAEB8
http://www.ime.usp.br/~rbrito : http://meusite.mackenzie.com.br/rbrito
Projects: algorithms.berlios.de : lame.sf.net : vrms.alioth.debian.org
