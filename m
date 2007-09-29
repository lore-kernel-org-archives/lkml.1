Return-Path: <linux-kernel-owner+w=401wt.eu-S1756281AbXI2IuN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756281AbXI2IuN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 04:50:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753802AbXI2It7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 04:49:59 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:46430 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190AbXI2It6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 04:49:58 -0400
Subject: Re: [15/17] SLUB: Support virtual fallback via SLAB_VFALLBACK
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Christoph Lameter <clameter@sgi.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Christoph Hellwig <hch@lst.de>,
       Mel Gorman <mel@skynet.ie>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>
In-Reply-To: <Pine.LNX.4.64.0709281114250.5149@schroedinger.engr.sgi.com>
References: <20070919033605.785839297@sgi.com>
	 <20070919033643.763818012@sgi.com>
	 <200709280742.38262.nickpiggin@yahoo.com.au>
	 <Pine.LNX.4.64.0709281014060.4713@schroedinger.engr.sgi.com>
	 <1191002119.18147.80.camel@lappy>
	 <Pine.LNX.4.64.0709281114250.5149@schroedinger.engr.sgi.com>
Content-Type: text/plain
Date: Sat, 29 Sep 2007 10:45:13 +0200
Message-Id: <1191055513.18147.97.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2007-09-28 at 11:20 -0700, Christoph Lameter wrote:

> Really? That means we can no longer even allocate stacks for forking.

I think I'm running with 4k stacks...

