Return-Path: <linux-kernel-owner+w=401wt.eu-S1757909AbYHNJlk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757909AbYHNJlk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 05:41:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752171AbYHNJlb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 05:41:31 -0400
Received: from brick.kernel.dk ([87.55.233.238]:4711 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751886AbYHNJlb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 05:41:31 -0400
Date: Thu, 14 Aug 2008 11:41:28 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Aaron Carroll <aaronc@gelato.unsw.edu.au>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] deadline-iosched: performance, style and documentation changes
Message-ID: <20080814094128.GS20055@kernel.dk>
References: <1218701835-17327-1-git-send-email-aaronc@gelato.unsw.edu.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1218701835-17327-1-git-send-email-aaronc@gelato.unsw.edu.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 14 2008, Aaron Carroll wrote:
> 
> Hi Jens,
> 
> Patch 1 changes deadline to dispatch in a CSCAN-like manner for improved
> throughput.  This fixes two performance issues, namely deadline avalanche
> that occurs under high load, and FCFS-like behaviour for mixed read/write
> workloads.  Benchmark results are below.
> 
> Patches 2 and 3 introduce some non-functional changes, mostly for style
> and documentation.

Looks good, thanks Aaron!

-- 
Jens Axboe

