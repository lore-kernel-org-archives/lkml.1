Return-Path: <linux-kernel-owner+w=401wt.eu-S1753268AbXLCQST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268AbXLCQST (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 11:18:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752747AbXLCQSB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 11:18:01 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:39800 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751067AbXLCQSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 11:18:00 -0500
Date: Mon, 3 Dec 2007 17:17:54 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] Suppress A.OUT library support if
	!CONFIG_BINFMT_AOUT [try #5]
Message-ID: <20071203161754.GU15974@stusta.de>
References: <20071111112538.GL21669@stusta.de> <20071109153432.20803.69832.stgit@warthog.procyon.org.uk> <20071109153437.20803.55096.stgit@warthog.procyon.org.uk> <18452.1196694929@redhat.com> <20071203160011.GA9058@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20071203160011.GA9058@linux-mips.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 03, 2007 at 04:00:11PM +0000, Ralf Baechle wrote:
> On Mon, Dec 03, 2007 at 03:15:29PM +0000, David Howells wrote:
> 
> > > - it adds #ifdef's in fs/binfmt_elf.c for code that is anyway
> > >   scheduled for removal in 2.6.25
> > 
> > I'm told (by Ralf) that removing this support will break Castle Wolfenstein or
> > something like that.
> > 
> > So unless you want hordes of rampaging MIPS users breaking down your door
> > whilst waving pitchforks and torches, maybe this needs to be reconsidered...
> 
> The wonders of asynchronous IRC communication ...
> 
> Wolfenstein is a true a.out binary and for a long time it was _the_ a.out
> binary.  If it was working no user would complain ;-)

Then it's unrelated to this issue.

At the time when I was playing Wolfenstein I was using M$ DOS, but I'd 
assume the "rampaging MIPS users" was another misunderstanding and 
it's i386?

>   Ralf

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

