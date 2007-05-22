Return-Path: <linux-kernel-owner+w=401wt.eu-S932263AbXEVJo3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932263AbXEVJo3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 05:44:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756627AbXEVJoV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 05:44:21 -0400
Received: from assei2bl6.telenet-ops.be ([195.130.133.69]:33173 "EHLO
	assei2bl6.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756037AbXEVJoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 05:44:20 -0400
Date: Tue, 22 May 2007 11:44:17 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, ak@suse.de,
       dada1@cosmosbay.com, wli@holomorphy.com, npiggin@suse.de,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-arch@vger.kernel.org
Subject: Re: [rfc] increase struct page size?!
In-Reply-To: <Pine.LNX.4.64.0705211737450.24160@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0705221142340.11196@anakin>
References: <20070518040854.GA15654@wotan.suse.de>
 <Pine.LNX.4.64.0705191121480.17008@schroedinger.engr.sgi.com>
 <464FCA28.9040009@cosmosbay.com> <200705201456.26283.ak@suse.de>
 <Pine.LNX.4.64.0705211006550.26282@schroedinger.engr.sgi.com>
 <20070522093050.0320d092.kamezawa.hiroyu@jp.fujitsu.com>
 <Pine.LNX.4.64.0705211737450.24160@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 May 2007, Christoph Lameter wrote:
> On Tue, 22 May 2007, KAMEZAWA Hiroyuki wrote:
> > For i386(32bit arch), there is not enough space for vmemmap.
> 
> I thought 32 bit would use flatmem? Is memory really sparse on 32 
> bit? Likely difficult due to lack of address space?

Throwing in more crazy comments: many m68k boxes have really sparse memory, due
to lack of memory and large address space.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
