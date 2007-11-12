Return-Path: <linux-kernel-owner+w=401wt.eu-S1756308AbXKLUNj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756308AbXKLUNj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 15:13:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751246AbXKLUNb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 15:13:31 -0500
Received: from waste.org ([66.93.16.53]:42883 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751192AbXKLUNa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 15:13:30 -0500
Date: Mon, 12 Nov 2007 14:13:22 -0600
From: Matt Mackall <mpm@selenic.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc2 slab vs slob tbench numbers
Message-ID: <20071112201322.GX17536@waste.org>
References: <200711092336.56172.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711092336.56172.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 09, 2007 at 11:36:56PM +1100, Nick Piggin wrote:
> Hi,
> 
> Just ran some tbench numbers (from dbench-3.04), on a 2 socket, 8
> core x86 system, with 1 NUMA node per socket. With kernel 2.6.24-rc2,
> comparing slab vs slub allocators.

Damn your misleading subject! I thought this was going to be about
something interesting.

-- 
Mathematics is the supreme nostalgia of our time.
