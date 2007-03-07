Return-Path: <linux-kernel-owner+w=401wt.eu-S2992737AbXCGWuG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992737AbXCGWuG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 17:50:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992730AbXCGWuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 17:50:05 -0500
Received: from waste.org ([66.93.16.53]:34870 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992809AbXCGWuB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 17:50:01 -0500
Date: Wed, 7 Mar 2007 16:36:50 -0600
From: Matt Mackall <mpm@selenic.com>
To: Adrian Bunk <bunk@stusta.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC: net-2.6.20 patch] remove unused exports
Message-ID: <20070307223650.GX23311@waste.org>
References: <20070307224059.GA3441@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070307224059.GA3441@stusta.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2007 at 11:40:59PM +0100, Adrian Bunk wrote:
> This patch removes the following not or no longer used exports:
> - drivers/char/random.c: secure_tcp_sequence_number

This part looks reasonable.

Acked-by: Matt Mackall <mpm@selenic.com>
-- 
Mathematics is the supreme nostalgia of our time.
