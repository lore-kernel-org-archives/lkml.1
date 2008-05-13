Return-Path: <linux-kernel-owner+w=401wt.eu-S1759588AbYEMKsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759588AbYEMKsT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 06:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750963AbYEMKsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 06:48:11 -0400
Received: from server.drzeus.cx ([85.8.24.28]:49312 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750810AbYEMKsJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 06:48:09 -0400
Date: Tue, 13 May 2008 12:47:45 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
       Steven French <sfrench@us.ibm.com>,
       Steven Whitehouse <swhiteho@redhat.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Jeff Garzik <jeff@garzik.org>, Ralf Baechle <ralf@linux-mips.org>,
       Jan Kara <jack@ucw.cz>, Anton Vorontsov <cbou@mail.ru>,
       Jens Axboe <jens.axboe@oracle.com>,
       Eric Van Hensbergen <ericvh@gmail.com>,
       Wim Van Sebroeck <wim@iguana.be>, Christian Zankel <chris@zankel.net>,
       Nicolas Pitre <nico@cam.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <clameter@sgi.com>, Erez Zadok <ezk@cs.sunysb.edu>,
       linux-kernel@vger.kernel.org
Subject: Re: git trees which are not yet in linux-next
Message-ID: <20080513124745.24158a93@mjolnir.drzeus.cx>
In-Reply-To: <20080513170052.eacecb02.sfr@canb.auug.org.au>
References: <20080502151206.b40f77ea.akpm@linux-foundation.org>
	<20080513083615.4e463f87@mjolnir.drzeus.cx>
	<20080513170052.eacecb02.sfr@canb.auug.org.au>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 May 2008 17:00:52 +1000
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Pierre,
> 
> On Tue, 13 May 2008 08:36:15 +0200 Pierre Ossman <drzeus-list@drzeus.cx> wrote:
> > 
> > The stuff I've pushed to Andrew has always been what I've been hoping
> > to merge in the next window, so it should just be a matter of renaming
> > the branch. There is a #next at the above URI now.
> 
> I have added that for tomorrow, thanks.
> 
> I noticed that that tree also has a for-linus branch.  Would that be bug
> fixes and stuff lined up for this release i.e. 2.6.26?  If so, I could
> add that to linux-next as well as one of the early merge trees.
> 

That's correct. But I've always made sure that for-linus is the base for
for-andrew (now next), so that should not be necessary.

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org
