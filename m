Return-Path: <linux-kernel-owner+w=401wt.eu-S1751698AbXDMCSD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751698AbXDMCSD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 22:18:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752221AbXDMCSD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 22:18:03 -0400
Received: from waste.org ([66.93.16.53]:50552 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751698AbXDMCSB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 22:18:01 -0400
Date: Thu, 12 Apr 2007 21:05:30 -0500
From: Matt Mackall <mpm@selenic.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       William Lee Irwin III <wli@holomorphy.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/13] maps: pagemap, kpagemap, and related cleanups
Message-ID: <20070413020530.GM11115@waste.org>
References: <1.486631555@selenic.com> <20070412231050.GN2986@holomorphy.com> <20070412163235.dd030637.akpm@linux-foundation.org> <461ECB9C.8060000@yahoo.com.au> <20070412174201.065068b2.akpm@linux-foundation.org> <461ED96C.5030606@yahoo.com.au> <20070412182213.a18cc4a7.akpm@linux-foundation.org> <461EE005.6070605@yahoo.com.au> <20070412185723.5a5f0443.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070412185723.5a5f0443.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2007 at 06:57:23PM -0700, Andrew Morton wrote:
> I guess one could generate an answer to the static question with systemtap,
> by accumulating running counts across the application lifetime and then
> snapshotting them.  Sounds hard though.

You'd have to do it from boot onward to get a complete system image.
One way to look at it is that systemtap can give you the derivative of
the information, and you have to integrate it.

-- 
Mathematics is the supreme nostalgia of our time.
