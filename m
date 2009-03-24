Return-Path: <linux-kernel-owner+w=401wt.eu-S1759121AbZCXSCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759121AbZCXSCV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 14:02:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755924AbZCXSCM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 14:02:12 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:37498
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755391AbZCXSCK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 14:02:10 -0400
X-Greylist: delayed 905 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Mar 2009 14:02:10 EDT
X-BigFish: VPS-41(zz542N1418M1432R14ffO4015M1805M936fK9371Pzz1202hzzz2dh6bh95p61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [microblaze-uclinux] Re: Microblaze linux support
Date: Tue, 24 Mar 2009 10:46:59 -0700
In-Reply-To: <49C8FBB5.5010107@monstr.eu>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [microblaze-uclinux] Re: Microblaze linux support
Thread-Index: Acmsl0arwHfyesoqRzKwrT9pojBNpAAERt7Q
References: <1237408284-8674-1-git-send-email-monstr@monstr.eu> <49C8FBB5.5010107@monstr.eu>
From: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
To: <microblaze-uclinux@itee.uq.edu.au>
CC: <linux-kernel@vger.kernel.org>, <john.williams@petalogix.com>,
       "John Linn" <linnj@xilinx.com>, "Arnd Bergmann" <arnd@arndb.de>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Randy Dunlap" <randy.dunlap@oracle.com>, "Ingo Molnar" <mingo@elte.hu>
X-OriginalArrivalTime: 24 Mar 2009 17:46:59.0538 (UTC) FILETIME=[88250320:01C9ACA8]
Message-ID: <20090324174700.5C9B91A10058@mail196-va3.bigfish.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> -----Original Message-----
> From: owner-microblaze-uclinux@itee.uq.edu.au 
> [mailto:owner-microblaze-uclinux@itee.uq.edu.au] On Behalf Of 
> Michal Simek
> Sent: Tuesday, March 24, 2009 8:27 AM
> To: monstr@monstr.eu
> Cc: linux-kernel@vger.kernel.org; 
> john.williams@petalogix.com; John Linn; Arnd Bergmann; Thomas 
> Gleixner; Randy Dunlap; Ingo Molnar; microblaze-uclinux@itee.uq.edu.au
> Subject: [microblaze-uclinux] Re: Microblaze linux support
> 
> Hi all,
> > Hi all,
> >
> > I think that is the right time to send you next pack with 
> > Microblaze support. It is seventh pack - some previous packs
> > was review by community and I hope there are not any big faults.
> >
> > We tested this kernel on some boards.
> > We have GIT server up and gitweb is available at 
> http://developer.petalogix.com/git/gitweb.cgi
> >
> > All information about git clone you can find on gitweb.
> > This pack is available in for-linus branch. Information 
> about other branches are on gitweb too.
> >
> > More information about microblaze fdt kernel you can find 
> at www.monstr.eu/fdt/
> > If you want to test kernel with microblaze toolchain let me know.
> >
> > I added only uart16550 and uartlite support - that's 
> enought for first merge.
> >
> >
> > Thanks for you comments and especially for your ACK,
> > Michal
> >   
> It is a week ago when I sent v7 pack to LKML for reviewing.
> 
> I have got ACK from John Williams who is the best person from 
> microblaze
> linux community.
> I got ACK from Randy Dunlap for Kconfig and Makefile patches.
> Thomas Gleixner reviewed IRQ and Timer code.
> Ingo Molnar confirms me that all coding style violation (checking with
> checkpatch.pl) are false positive.
> 
> John L: Could you give me ACK from Xilinx?
> 
> Thanks,
> Michal


Acked-by: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>

Steve

This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.


