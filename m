Return-Path: <linux-kernel-owner+w=401wt.eu-S1754552AbXG1QLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552AbXG1QLT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 12:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751954AbXG1QLM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 12:11:12 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:33432 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888AbXG1QLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 12:11:11 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46AB6A83.1060205@s5r6.in-berlin.de>
Date: Sat, 28 Jul 2007 18:10:43 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.4) Gecko/20070609 SeaMonkey/1.1.2
MIME-Version: 1.0
To: Martin Steigerwald <Martin@lichtvoll.de>
CC: ck@vds.kolivas.org, Matthew Hawkins <darthmdh@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Kasper Sandberg <lkml@metanurb.dk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Reporting bugs (was Re: [ck] Re: Linus 2.6.23-rc1)
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org> <alpine.LFD.0.999.0707271922050.3442@woody.linux-foundation.org> <b21f8390707280036m6781856ckb64b5f10d2295fa5@mail.gmail.com> (sfid-20070728_101016_101479_8E8AB210) <200707281240.42308.Martin@lichtvoll.de>
In-Reply-To: <200707281240.42308.Martin@lichtvoll.de>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Steigerwald wrote:
> There are just about 9000 bugs in the kernel bugtracker and about 150000 
> bugs in the KDE bugtracker. Granted KDE bugtracker includes a lot of 
> applications, but still I think the number of bug reports in the kernel 
> bugtracker is ridicolously low. And I think thats because many users 
> don't bother to report bugs upstream for the Linux kernel, not because 
> that those bugs aren't there.
> 
> I hope that the ck mailing list community will continue to be active and 
> possibly try to get swap prefetch and some other goodies of the ck 
> patchset into mainline. And I think it would also be a good idea for ck 
> mailing list community to report desktop related issues in the kernel 
> bugtracker. I think I will take the courage next time I find anything, 
> and report it straight there.

A word of caution about bugzilla.kernel.org, to those who don't know
already:  By far not all maintainers and developers use bugzilla.
I don't know for which subsystems it makes sense to file a report in
bugzilla.  I think your best bet is to report at the mailinglists
listed in linux/MAINTAINERS.
-- 
Stefan Richter
-=====-=-=== -=== ===--
http://arcgraph.de/sr/
