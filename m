Return-Path: <linux-kernel-owner+w=401wt.eu-S932620AbXHMX2K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932620AbXHMX2K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 19:28:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753408AbXHMX1p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 19:27:45 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:55506 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761790AbXHMX1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 19:27:43 -0400
Date: Mon, 13 Aug 2007 16:27:42 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andi Kleen <ak@suse.de>
cc: Mel Gorman <mel@skynet.ie>, Lee.Schermerhorn@hp.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 3/4] Embed zone_id information within the zonelist->zones
 pointer
In-Reply-To: <20070814001659.GP3406@bingen.suse.de>
Message-ID: <Pine.LNX.4.64.0708131625320.19910@schroedinger.engr.sgi.com>
References: <20070813225020.GE3406@bingen.suse.de>
 <Pine.LNX.4.64.0708131457190.28445@schroedinger.engr.sgi.com>
 <20070813225841.GG3406@bingen.suse.de> <Pine.LNX.4.64.0708131506030.28502@schroedinger.engr.sgi.com>
 <20070813230801.GH3406@bingen.suse.de> <Pine.LNX.4.64.0708131536340.29946@schroedinger.engr.sgi.com>
 <20070813234322.GJ3406@bingen.suse.de> <Pine.LNX.4.64.0708131553050.30626@schroedinger.engr.sgi.com>
 <20070814000041.GL3406@bingen.suse.de> <Pine.LNX.4.64.0708131614270.19910@schroedinger.engr.sgi.com>
 <20070814001659.GP3406@bingen.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Aug 2007, Andi Kleen wrote:

> > Ok then lets do it.
> 
> Conversion only makes sense once an API with a explicit mask
> is in. Otherwise we have muddled semantics again.

pci_set_consistent_dma_mask

has that.

