Return-Path: <linux-kernel-owner+w=401wt.eu-S1760472AbZCXPdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760472AbZCXPdi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 11:33:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759202AbZCXPdT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 11:33:19 -0400
Received: from wa4ehsobe005.messaging.microsoft.com ([216.32.181.15]:21740
	"EHLO WA4EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760784AbZCXPdS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 11:33:18 -0400
X-BigFish: VPS-46(zz542N1418M1432R14ffO1b0aM4015M1805M936fK9371Pzz1202hzzz2dh6bh95p61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Microblaze linux support
Date: Tue, 24 Mar 2009 09:33:13 -0600
In-Reply-To: <49C8FBB5.5010107@monstr.eu>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Microblaze linux support
Thread-Index: AcmslPXlJ1kPM91DSJeVJWNoKUMeHgAAIQGA
References: <1237408284-8674-1-git-send-email-monstr@monstr.eu> <49C8FBB5.5010107@monstr.eu>
From: John Linn <John.Linn@xilinx.com>
To: <monstr@monstr.eu>
CC: <linux-kernel@vger.kernel.org>, <john.williams@petalogix.com>,
       "Arnd Bergmann" <arnd@arndb.de>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Randy Dunlap" <randy.dunlap@oracle.com>, "Ingo Molnar" <mingo@elte.hu>,
       <microblaze-uclinux@itee.uq.edu.au>
X-OriginalArrivalTime: 24 Mar 2009 15:33:13.0681 (UTC) FILETIME=[D85C6C10:01C9AC95]
Message-ID: <20090324153314.C8BD144806B@mail135-wa4.bigfish.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Michal Simek [mailto:monstr@monstr.eu]
> Sent: Tuesday, March 24, 2009 9:27 AM
> To: monstr@monstr.eu
> Cc: linux-kernel@vger.kernel.org; john.williams@petalogix.com; John
Linn; Arnd Bergmann; Thomas
> Gleixner; Randy Dunlap; Ingo Molnar; microblaze-uclinux@itee.uq.edu.au
> Subject: Re: Microblaze linux support
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
http://developer.petalogix.com/git/gitweb.cgi
> >
> > All information about git clone you can find on gitweb.
> > This pack is available in for-linus branch. Information about other
branches are on gitweb too.
> >
> > More information about microblaze fdt kernel you can find at
www.monstr.eu/fdt/
> > If you want to test kernel with microblaze toolchain let me know.
> >
> > I added only uart16550 and uartlite support - that's enought for
first merge.
> >
> >
> > Thanks for you comments and especially for your ACK,
> > Michal
> >
> It is a week ago when I sent v7 pack to LKML for reviewing.
> 
> I have got ACK from John Williams who is the best person from
microblaze
> linux community.
> I got ACK from Randy Dunlap for Kconfig and Makefile patches.
> Thomas Gleixner reviewed IRQ and Timer code.
> Ingo Molnar confirms me that all coding style violation (checking with
> checkpatch.pl) are false positive.
> 
> John L: Could you give me ACK from Xilinx?

Acked-by: John Linn <john.linn@xilinx.com>

Thanks for all your work to move this forward.

-- John

> 
> Thanks,
> Michal
> 
> 
> 
> >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe
linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >
> 
> 
> --
> Michal Simek, Ing. (M.Eng)
> w: www.monstr.eu p: +42-0-721842854
> 


This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.


