Return-Path: <linux-kernel-owner+w=401wt.eu-S965080AbXA3AJl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965080AbXA3AJl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 19:09:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965085AbXA3AJl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 19:09:41 -0500
Received: from smtp.osdl.org ([65.172.181.24]:34590 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965080AbXA3AJk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 19:09:40 -0500
Date: Mon, 29 Jan 2007 16:09:21 -0800
From: Andrew Morton <akpm@osdl.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>, Mel Gorman <mel@csn.ul.ie>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Christoph Lameter <clameter@engr.sgi.com>
Subject: Re: [PATCH 0/8] Create ZONE_MOVABLE to partition memory between
 movable and non-movable pages
Message-Id: <20070129160921.7b362c8d.akpm@osdl.org>
In-Reply-To: <Pine.LNX.4.64.0701291533500.1169@schroedinger.engr.sgi.com>
References: <20070125234458.28809.5412.sendpatchset@skynet.skynet.ie>
	<20070126030753.03529e7a.akpm@osdl.org>
	<Pine.LNX.4.64.0701260751230.6141@schroedinger.engr.sgi.com>
	<20070126114615.5aa9e213.akpm@osdl.org>
	<Pine.LNX.4.64.0701261147300.15394@schroedinger.engr.sgi.com>
	<20070126122747.dde74c97.akpm@osdl.org>
	<Pine.LNX.4.64.0701291349450.548@schroedinger.engr.sgi.com>
	<20070129143654.27fcd4a4.akpm@osdl.org>
	<Pine.LNX.4.64.0701291441260.1102@schroedinger.engr.sgi.com>
	<20070129225000.GG6602@flint.arm.linux.org.uk>
	<Pine.LNX.4.64.0701291533500.1169@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Jan 2007 15:37:29 -0800 (PST)
Christoph Lameter <clameter@sgi.com> wrote:

> With a alloc_pages_range() one would be able to specify upper and lower 
> boundaries.

Is there a proposal anywhere regarding how this would be implemented?
