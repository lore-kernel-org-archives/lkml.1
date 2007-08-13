Return-Path: <linux-kernel-owner+w=401wt.eu-S933231AbXHMV23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933231AbXHMV23 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 17:28:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754258AbXHMV2K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 17:28:10 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3746 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753233AbXHMV2I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 17:28:08 -0400
Subject: Re: [PATCH] [438/2many] MAINTAINERS - SLAB ALLOCATOR
From: Joe Perches <joe@perches.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: torvalds@linux-foundation.org, penberg@cs.helsinki.fi, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <Pine.LNX.4.64.0708131421070.28026@schroedinger.engr.sgi.com>
References: <46bffbc9.9Jtz7kOTKn1mqlkq%joe@perches.com>
	 <Pine.LNX.4.64.0708131345130.27728@schroedinger.engr.sgi.com>
	 <1187039557.10249.312.camel@localhost>
	 <Pine.LNX.4.64.0708131421070.28026@schroedinger.engr.sgi.com>
Content-Type: text/plain
Date: Mon, 13 Aug 2007 14:27:46 -0700
Message-Id: <1187040466.10249.326.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-13 at 14:21 -0700, Christoph Lameter wrote:
> On Mon, 13 Aug 2007, Joe Perches wrote:
> > Do you want slob too?
> Sure we usually have to update all the slab allocators for changes.

SLAB/SLOB/SLUB ALLOCATORS
P:	Christoph Lameter
M:	clameter@sgi.com
P:	Pekka Enberg
M:	penberg@cs.helsinki.fi
L:	linux-mm@kvack.org
S:	Maintained
F:	include/linux/sl?b*.h
F:	mm/sl?b.c


