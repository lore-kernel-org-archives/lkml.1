Return-Path: <linux-kernel-owner+w=401wt.eu-S1762486AbXKHV2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762486AbXKHV2m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 16:28:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759563AbXKHV2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 16:28:33 -0500
Received: from relay1.corp.sgi.com ([192.48.171.29]:39689 "EHLO relay.sgi.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759323AbXKHV2c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 16:28:32 -0500
Date: Thu, 8 Nov 2007 13:28:31 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Matt Mackall <mpm@selenic.com>
cc: Mel Gorman <mel@skynet.ie>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch 02/23] SLUB: Rename NUMA defrag_ratio to remote_node_defrag_ratio
In-Reply-To: <20071108210348.GX19691@waste.org>
Message-ID: <Pine.LNX.4.64.0711081328121.10596@schroedinger.engr.sgi.com>
References: <20071107011130.382244340@sgi.com> <20071107011226.844437184@sgi.com>
 <20071108145044.GB2591@skynet.ie> <20071108172548.GW17536@waste.org>
 <Pine.LNX.4.64.0711081116060.9279@schroedinger.engr.sgi.com>
 <20071108194735.GW19691@waste.org> <Pine.LNX.4.64.0711081159120.9966@schroedinger.engr.sgi.com>
 <20071108210348.GX19691@waste.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Nov 2007, Matt Mackall wrote:

> But perhaps I should just add a lightweight RNG to random.c and be
> done with it.

It would be appreciated.
