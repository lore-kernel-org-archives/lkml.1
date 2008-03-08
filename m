Return-Path: <linux-kernel-owner+w=401wt.eu-S1760581AbYCHCmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760581AbYCHCmu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 21:42:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757061AbYCHCmn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 21:42:43 -0500
Received: from relay1.sgi.com ([192.48.171.29]:42622 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757004AbYCHCmn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 21:42:43 -0500
Date: Fri, 7 Mar 2008 18:42:21 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andi Kleen <andi@firstfloor.org>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] [0/13] General DMA zone rework
In-Reply-To: <200803071007.493903088@firstfloor.org>
Message-ID: <Pine.LNX.4.64.0803071841020.12220@schroedinger.engr.sgi.com>
References: <200803071007.493903088@firstfloor.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Mar 2008, Andi Kleen wrote:

> The longer term goal is to convert all GFP_DMA allocations
> to always specify the correct mask and then eventually remove
> GFP_DMA.
> 
> Especially I hope kmalloc/kmem_cache_alloc GFP_DMA can be
> removed soon. I have some patches to eliminate those users.
> Then slab wouldn't need to maintain DMA caches anymore.

That would be greatly appreciated. Thanks for doing this.


