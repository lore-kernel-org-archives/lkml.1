Return-Path: <linux-kernel-owner+w=401wt.eu-S971519AbXEIAna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S971519AbXEIAna (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 20:43:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S971354AbXEIAnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 20:43:07 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:48274 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S971457AbXEIAnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 20:43:05 -0400
Date: Tue, 8 May 2007 17:43:04 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Matt Mackall <mpm@selenic.com>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: + fix-spellings-of-slab-allocator-section-in-init-kconfig.patch
 added to -mm tree
In-Reply-To: <20070509003323.GX11115@waste.org>
Message-ID: <Pine.LNX.4.64.0705081742430.16860@schroedinger.engr.sgi.com>
References: <200705082302.l48N2KrZ004229@shell0.pdx.osdl.net>
 <20070509002307.GV11115@waste.org> <20070509013220.02093f2e@the-village.bc.nu>
 <20070509003323.GX11115@waste.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 May 2007, Matt Mackall wrote:

> Further, the received wisdom that fragmentation of SLAB-like systems
> is better is not above doubt. Our own issues with dcache fragmentation
> suggest it's far from perfect.

I guess that you have not seen the slab defrag code for SLUB then.

