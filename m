Return-Path: <linux-kernel-owner+w=401wt.eu-S1763013AbXGFR3d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763013AbXGFR3d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 13:29:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757258AbXGFR30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 13:29:26 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:52399 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756396AbXGFR3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 13:29:25 -0400
Date: Fri, 6 Jul 2007 10:29:24 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Johannes Berg <johannes@sipsolutions.net>
cc: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] slub: don't export static kmem_cache_open
In-Reply-To: <1183628260.3818.31.camel@johannes.berg>
Message-ID: <Pine.LNX.4.64.0707061028001.30516@schroedinger.engr.sgi.com>
References: <1183628260.3818.31.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Jul 2007, Johannes Berg wrote:

> kmem_cache_open is static so shouldn't be exported.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

I already fixed that. Patch is in Andrew's tree.
