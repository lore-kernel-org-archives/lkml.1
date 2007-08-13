Return-Path: <linux-kernel-owner+w=401wt.eu-S934644AbXHMVWO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934644AbXHMVWO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 17:22:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752612AbXHMVVy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 17:21:54 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:48947 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752111AbXHMVVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 17:21:53 -0400
Date: Mon, 13 Aug 2007 14:21:52 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Joe Perches <joe@perches.com>
cc: torvalds@linux-foundation.org, penberg@cs.helsinki.fi, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] [438/2many] MAINTAINERS - SLAB ALLOCATOR
In-Reply-To: <1187039557.10249.312.camel@localhost>
Message-ID: <Pine.LNX.4.64.0708131421070.28026@schroedinger.engr.sgi.com>
References: <46bffbc9.9Jtz7kOTKn1mqlkq%joe@perches.com> 
 <Pine.LNX.4.64.0708131345130.27728@schroedinger.engr.sgi.com>
 <1187039557.10249.312.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Aug 2007, Joe Perches wrote:

> Do you want slob too?

Sure we usually have to update all the slab allocators for changes.
 
> SLAB/SLUB ALLOCATOR
> P:	Christoph Lameter
> M:	clameter@sgi.com
> P:	Pekka Enberg
> M:	penberg@cs.helsinki.fi
> L:	linux-mm@kvack.org
> S:	Maintained
> F:	include/linux/sl?b*.h
> F:	mm/sl?b.c

This one.

