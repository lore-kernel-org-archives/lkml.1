Return-Path: <linux-kernel-owner+w=401wt.eu-S1766848AbXEBUBF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766848AbXEBUBF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 16:01:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766873AbXEBUBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 16:01:05 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56519 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766848AbXEBUBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 16:01:04 -0400
Date: Wed, 2 May 2007 21:01:00 +0100 (BST)
From: James Simmons <jsimmons@infradead.org>
To: "Antonino A. Daplas" <adaplas@gmail.com>
cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org, Michael Schmitz <schmitz@debian.org>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: [patch 05/33] m68k: Atari fb revival
In-Reply-To: <1178056237.4606.19.camel@daplas>
Message-ID: <Pine.LNX.4.64.0705022100030.6403@pentafluge.infradead.org>
References: <20070501203234.252205858@mail.of.borg>  <20070501203330.469191361@mail.of.borg>
 <1178056237.4606.19.camel@daplas>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> On Tue, 2007-05-01 at 22:32 +0200, Geert Uytterhoeven wrote:
> > plain text document attachment (636-atafb.diff)
> > From: Michael Schmitz <schmitz@opal.biophys.uni-duesseldorf.de>
> > 
> > Update the atari fb to 2.6 by Michael Schmitz,
> 
> Finally :-). That leaves only pm3fb that needs porting.
> 
> It still contains remnants of 2.4 code though, ie, FBCON_HAS_*, but
> that's minor.

Yeah!!! Its a good step forward. Needs more cleanup down the road.
 
> > Reformatting and rewrite of bit plane functions by Roman Zippel,
> > A few more fixes by Geert Uytterhoeven.
> > 
> > Signed-off-by: Michael Schmitz <schmitz@debian.org>
> > Signed-off-by: Roman Zippel <zippel@linux-m68k.org>
> > Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Acked-by: Antonino Daplas <adaplas@gmail.com>

Acked-by: James Simmons <jsimmons@infradead.org>
