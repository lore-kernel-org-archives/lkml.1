Return-Path: <linux-kernel-owner+w=401wt.eu-S1764777AbXEUTMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764777AbXEUTMR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 15:12:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757508AbXEUTMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 15:12:06 -0400
Received: from brick.kernel.dk ([80.160.20.94]:4836 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757052AbXEUTMD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 15:12:03 -0400
Date: Mon, 21 May 2007 21:09:41 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: Christoph Lameter <clameter@sgi.com>,
       Srihari Vijayaraghavan <sriharivijayaraghavan@yahoo.com.au>,
       Oliver Xymoron <oxymoron@waste.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PROBLEM] 2.6.22-rc2 panics on x86-64 with slub
Message-ID: <20070521190941.GB4705@kernel.dk>
References: <20070520133505.46147.qmail@web52609.mail.re2.yahoo.com> <Pine.LNX.4.64.0705210917280.25871@schroedinger.engr.sgi.com> <Pine.LNX.4.64.0705211835140.26666@blonde.wat.veritas.com> <Pine.LNX.4.64.0705211121570.26794@schroedinger.engr.sgi.com> <Pine.LNX.4.64.0705211930370.31659@blonde.wat.veritas.com> <Pine.LNX.4.64.0705211147100.26970@schroedinger.engr.sgi.com> <20070521190043.GA4705@kernel.dk> <Pine.LNX.4.64.0705212005110.2550@blonde.wat.veritas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705212005110.2550@blonde.wat.veritas.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21 2007, Hugh Dickins wrote:
> On Mon, 21 May 2007, Jens Axboe wrote:
> > 
> > I can test whatever you want tomorrow morning, it was 100% repeatable
> > here. So which one, your patch or Hughs?
> 
> Great, thanks: Christoph's please - I'm sure he'll agree!

Alright, will do!

-- 
Jens Axboe

