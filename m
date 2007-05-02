Return-Path: <linux-kernel-owner+w=401wt.eu-S1161761AbXEBVOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161761AbXEBVOl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 17:14:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161782AbXEBVOl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 17:14:41 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:56105 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161761AbXEBVOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 17:14:40 -0400
Date: Wed, 2 May 2007 14:14:39 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slub: remove duplicate VM_BUG_ON
In-Reply-To: <4638F2DA.9080100@cs.helsinki.fi>
Message-ID: <Pine.LNX.4.64.0705021413570.2469@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0705022307310.16215@sbz-30.cs.Helsinki.FI>
 <Pine.LNX.4.64.0705021311440.1978@schroedinger.engr.sgi.com>
 <4638F2DA.9080100@cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 May 2007, Pekka Enberg wrote:

> Christoph Lameter wrote:
> > Patch is already in mm. Could you download all the patches after that before
> > testing? There was quite a number.
> 
> I am on 2.6.21-rc7-mm2. Me goes to wonder where Andrew's snapshots are...

Too much going on I think. I guess I saturated him with patches.
 
