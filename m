Return-Path: <linux-kernel-owner+w=401wt.eu-S1751651AbXB1FQM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751651AbXB1FQM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 00:16:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751684AbXB1FQM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 00:16:12 -0500
Received: from smtp.osdl.org ([65.172.181.24]:40155 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751651AbXB1FQM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 00:16:12 -0500
Date: Tue, 27 Feb 2007 21:16:28 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.21-rc2
Message-ID: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Oh well.. I'm not very proud of this, because quite frankly, -rc2 has way 
more changes than I really like.

And yeah, it's largely my fault, because I simply missed a V4L/DVB merge 
that came in before the merge window closed, but since I didn't notice it 
didn't make -rc1, and as such it got merged late and is in -rc2 instead.

But because I'll flail around wildly and rather blame anything else than 
my own incompetence, I'll just claim that all the other kernel developers 
have been irresponsible, and caused -rc2 to be bigger than needed. In some 
areas (you know who you are) it may even be true..

Apart from the V4L/DVB merge, we've got a late PARISC update, and a number 
of driver updates (ata, networking, usb) changes. Along with the normal 
smattering of random stuff (core networking, selinux, infiniband, agp, 
mips, arm).

Anyway, I really hope the thing starts calming down now, and everybody 
should take a hard look at the regressions lists that Adrian has started 
sending out. We already fixed some of them, but there is more to go..

Thanks,

		Linus
