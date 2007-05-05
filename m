Return-Path: <linux-kernel-owner+w=401wt.eu-S1423230AbXEEPnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423230AbXEEPnk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 11:43:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423217AbXEEPng
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 11:43:36 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:47386 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1423224AbXEEPnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 11:43:32 -0400
Date: Sat, 5 May 2007 08:43:31 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, dgc@sgi.com,
       Eric Dumazet <dada1@cosmosbay.com>, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [RFC 1/3] SLUB: slab_ops instead of constructors / destructors
In-Reply-To: <84144f020705050314s36510c98j70d1ca8e3770f00e@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0705050843230.26574@schroedinger.engr.sgi.com>
References: <20070504221555.642061626@sgi.com>  <20070504221708.363027097@sgi.com>
 <84144f020705050314s36510c98j70d1ca8e3770f00e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 May 2007, Pekka Enberg wrote:

> For consistency with other operations structures, can we make this
> struct kmem_cache_operations or kmem_cache_ops, please?

Ok.
 
