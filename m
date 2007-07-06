Return-Path: <linux-kernel-owner+w=401wt.eu-S1764344AbXGFRzb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764344AbXGFRzb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 13:55:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757809AbXGFRzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 13:55:23 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:53731 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759236AbXGFRzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 13:55:22 -0400
Date: Fri, 6 Jul 2007 10:55:22 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Johannes Berg <johannes@sipsolutions.net>
cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org
Subject: Re: [PATCH] slub: don't export static kmem_cache_open
In-Reply-To: <1183743340.3779.11.camel@johannes.berg>
Message-ID: <Pine.LNX.4.64.0707061054571.30575@schroedinger.engr.sgi.com>
References: <1183628260.3818.31.camel@johannes.berg> 
 <Pine.LNX.4.64.0707061028001.30516@schroedinger.engr.sgi.com>
 <1183743340.3779.11.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jul 2007, Johannes Berg wrote:

> > I already fixed that. Patch is in Andrew's tree.
> 
> Oh good. I actually got build problems from that due to a powerpc64 gcc
> bug so... :)

Well in that case we may have to push the patch into 2.6.22 or stable.

