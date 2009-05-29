Return-Path: <linux-kernel-owner+w=401wt.eu-S1759998AbZE2OjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759998AbZE2OjT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 10:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759485AbZE2OjH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 10:39:07 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:35918
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759056AbZE2OjG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 10:39:06 -0400
X-SpamScore: -30
X-BigFish: VPS-30(zz542N1432R14ffO1805M9371Pzz1202hzzz2dh6bh17dh17ch95n61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [microblaze-uclinux] Microblaze MMU v2
Date: Fri, 29 May 2009 08:39:04 -0600
In-Reply-To: <1243406874-3917-1-git-send-email-monstr@monstr.eu>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [microblaze-uclinux] Microblaze MMU v2
Thread-Index: AcnemQWPXoG3CSMRRZqjK0Jz7IrSuwB0eRFA
References: <1243406874-3917-1-git-send-email-monstr@monstr.eu>
From: John Linn <John.Linn@xilinx.com>
To: <microblaze-uclinux@itee.uq.edu.au>, <linux-kernel@vger.kernel.org>
CC: <john.williams@petalogix.com>, <michal.simek@petalogix.com>
X-OriginalArrivalTime: 29 May 2009 14:39:05.0664 (UTC) FILETIME=[37A7DC00:01C9E06B]
Message-ID: <20090529143906.570B082804F@mail59-va3.bigfish.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: John Linn <john.linn@xilinx.com>

Looks like great progress,
John

> -----Original Message-----
> From: owner-microblaze-uclinux@lists.itee.uq.edu.au
[mailto:owner-microblaze-
> uclinux@lists.itee.uq.edu.au] On Behalf Of Michal Simek
> Sent: Wednesday, May 27, 2009 12:47 AM
> To: linux-kernel@vger.kernel.org
> Cc: john.williams@petalogix.com; microblaze-uclinux@itee.uq.edu.au;
michal.simek@petalogix.com
> Subject: [microblaze-uclinux] Microblaze MMU v2
> 
> Hi All,
> 
> This is bunch of patches for Microblaze MMU kernel support version 2.
> There is one problem(not functional) with uaccess.h which I know about
and I would like
> to fix it till rc2 with Arnd's new generic patches which I hope will
be there.
> 
> All changes are available at
git://git.monstr.eu/linux-2.6-microblaze.git
> next branch.
> 
> Version 1 is available at mmu_v1 branch.
> 
> Changes in version 2.
> I added all reported problems - mmu_v1 branch contains separate
commits for that
> I fixed problems with stat.h and fcntl.h - there are prepared for Arnd
generic version.
> 
> Thanks for your time and review.
> 
> I believe that this is the last version for review in LKML.
> 
> Thanks for your ACK,
> Michal
> 
> 
> 
> 
> 
> 
> ___________________________
> microblaze-uclinux mailing list
> microblaze-uclinux@itee.uq.edu.au
> Project Home Page :
http://www.itee.uq.edu.au/~jwilliams/mblaze-uclinux
> Mailing List Archive :
http://www.itee.uq.edu.au/~listarch/microblaze-uclinux/
> 


This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.


