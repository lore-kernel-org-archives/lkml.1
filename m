Return-Path: <linux-kernel-owner+w=401wt.eu-S1032243AbXEHVMv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032243AbXEHVMv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 17:12:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1032209AbXEHVMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 17:12:46 -0400
Received: from gherkin.frus.com ([192.158.254.49]:33733 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1032173AbXEHVMp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 17:12:45 -0400
Subject: Re: New Mitsumi legacy CD-ROM driver
In-Reply-To: <200705082213.44042.linux@rainbow-software.org> "from Ondrej Zary
 at May 8, 2007 10:13:43 pm"
To: Ondrej Zary <linux@rainbow-software.org>
Date: Tue, 8 May 2007 16:12:36 -0500 (CDT)
CC: Rene Herman <rene.herman@gmail.com>, Andrew Morton <akpm@osdl.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
X-Mailer: ELM [version 2.4ME+ PL82 (25)]
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Message-Id: <20070508211236.95087DBA1@gherkin.frus.com>
From: rct@gherkin.frus.com (Bob Tracy)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ondrej Zary wrote:
> On Tuesday 08 May 2007 11:42:08 you wrote:
> > Mitsumi (mcdx, this driver), panasonic (sbpcd) and sony (cdu31a) are
> > somewhat of an exception in so far that controllers for those three are
> > still around on a lot of old ISA soundcards though. Moreover, I have the
> > drives to test that trio so after this mitsumi driver is complete and in
> > good shape I'll do the other two as well.
> 
> I fixed cdu31a some time ago - so it at least works.
> I also have a Panasonic drive with controller integrated on a SB16 sound card 
> but haven't tried it with Linux yet.
> 
> It's nice to see new driver for these old drives.

Agreed.  I've still got a GUS in one of my museum pieces that runs
MS-Win 3.1 by default.  The BIOS is too old to support booting from
anything except hda, sda and floppy, but because I enjoy pain I'll
be happy to modify the startup floppy images for a 2.6.X-based live
CD distro (DSL, anyone?) and give the new drivers a spin when they're
ready for testing.  The motherboard is a curiosity: it has ISA, PCI,
*and* VLB slots.  The processor is an AMD 5x86 (think 486 on steroids).
I *might* have 32 MB of RAM to work with: I simply don't remember :-).

-- 
-----------------------------------------------------------------------
Bob Tracy                   WTO + WIPO = DMCA? http://www.anti-dmca.org
rct@frus.com
-----------------------------------------------------------------------
