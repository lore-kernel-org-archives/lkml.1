Return-Path: <linux-kernel-owner+w=401wt.eu-S1760106AbZAWD77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760106AbZAWD77 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 22:59:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754709AbZAWD7v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 22:59:51 -0500
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:2598 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754643AbZAWD7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 22:59:50 -0500
Subject: Re: [patch] SLQB slab allocator
From: Joe Perches <joe@perches.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lin Ming <ming.m.lin@intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Christoph Lameter <clameter@engr.sgi.com>
In-Reply-To: <20090123033520.GC20098@wotan.suse.de>
References: <20090121143008.GV24891@wotan.suse.de>
	 <1232560770.8025.7.camel@localhost>  <20090123033520.GC20098@wotan.suse.de>
Content-Type: text/plain
Date: Thu, 22 Jan 2009 20:00:47 -0800
Message-Id: <1232683247.15489.103.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2-1.2mdv2009.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-01-23 at 04:35 +0100, Nick Piggin wrote:
> That's a fair point. Hugh dislikes it too, I see ;) What to do... I
> had been toying with the idea that if slqb (or slub) becomes "the"
> allocator, then we could rename it all back to slAb after replacing
> the existing slab?

maybe SLIB (slab-improved) or SLAB_NG or NSLAB or SLABX
Who says it has to be 4 letters?

> Or I could make it a 128 bit allocator and call it SLZB, which would
> definitely make it "the final" allocator ;)

That leads to the phone book game.

SLZZB - and a crystal bridge now spans the fissure.

Hmm, wrong game.

cheers, j

