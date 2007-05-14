Return-Path: <linux-kernel-owner+w=401wt.eu-S1756727AbXENVMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756727AbXENVMb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 17:12:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751090AbXENVMZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 17:12:25 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:46546 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750940AbXENVMY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 17:12:24 -0400
Date: Mon, 14 May 2007 23:13:20 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kumar Gala <galak@kernel.crashing.org>, Li Yang <leoli@freescale.com>,
       Linus <torvalds@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 1/2] kbuild: Add "Section mismatch" warning whitelist for powerpc
Message-ID: <20070514211320.GA12094@uranus.ravnborg.org>
References: <46483FAC.60503@freescale.com> <20070514110636.GB10143@uranus.ravnborg.org> <3DF58590-DFD9-4665-8C47-33F407AAD1E7@kernel.crashing.org> <20070514123046.d75cc170.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070514123046.d75cc170.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 14, 2007 at 12:30:46PM -0700, Andrew Morton wrote:
> > >>
> > >> Signed-off-by: Li Yang <leoli@freescale.com>
> > > Acked-by: Sam Ravnborg <sam@ravnborg.org>
> 
> I always get confused when a git-tree-owner says "acked-by" against a patch
> which falls within his tree's area.  An acked-by would mean "I'm OK with
> the patch, please apply it".  But I'd have expected to see a "thanks,
> applied" instead.

I have saved the patch so I can apply it if Linus does not do so.
My "Acked-by:" was actually mostly to tell Linus that I was OK
with the modpost changes although I did not write so in my mail.

So if this is not picked up by Linus I will pick up this patch.

	Sam
