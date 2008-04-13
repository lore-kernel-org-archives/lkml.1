Return-Path: <linux-kernel-owner+w=401wt.eu-S1756527AbYDMIMI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756527AbYDMIMI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 04:12:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752286AbYDMILw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 04:11:52 -0400
Received: from edna.telenet-ops.be ([195.130.132.58]:57781 "EHLO
	edna.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601AbYDMILu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 04:11:50 -0400
Date: Sun, 13 Apr 2008 10:11:46 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Michael Schmitz <schmitz@zirkon.biophys.uni-duesseldorf.de>
cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org, linux-m68k@vger.kernel.org
Subject: Re: 2.6.25-rc8-mm2
In-Reply-To: <alpine.DEB.1.00.0804130944380.1190@zirkon.biophys.uni-duesseldorf.de>
Message-ID: <Pine.LNX.4.64.0804131010090.28304@anakin>
References: <20080410203354.f0a6f464.akpm@linux-foundation.org>
 <20080411134036.GB3821@cs181133002.pp.htv.fi> <20080411212222.b3c1177e.akpm@linux-foundation.org>
 <20080412184317.GB18122@skywalker> <alpine.DEB.1.00.0804130944380.1190@zirkon.biophys.uni-duesseldorf.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Apr 2008, Michael Schmitz wrote:
> > > I saw some related linux-ext4 email float past yesterday, so something
> > > might be happening.
> > 
> > It would really help if we can get some m68k people to look at patch
> > i posted.
> > 
> > http://article.gmane.org/gmane.comp.file-systems.ext4/5944
> 
> I'd love to - only I can't seem to compile 2.6.25 at all. What's the minimum
> gcc version I should use?

My cross-compiler is gcc version 4.1.2 20061115 (prerelease) (Debian 4.1.1-21).

Gr{oetje,eeting}s,

						Geert

P.S. I'll look into it when I find some time, but you may beat me to it...
--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
