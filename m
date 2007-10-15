Return-Path: <linux-kernel-owner+w=401wt.eu-S1764390AbXJOTvn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764390AbXJOTvn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 15:51:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758622AbXJOTvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 15:51:16 -0400
Received: from waste.org ([66.93.16.53]:36046 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758084AbXJOTvP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 15:51:15 -0400
Date: Mon, 15 Oct 2007 14:51:11 -0500
From: Matt Mackall <mpm@selenic.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/21] KGDB: Pass skb via NET_POLL rx routine
Message-ID: <20071015195111.GS19691@waste.org>
References: <4713B251.7000400@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4713B251.7000400@windriver.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2007 at 01:32:49PM -0500, Jason Wessel wrote:
> Signed-off-by: Jason Wessel <jason.wessel@windriver.com>

> netpoll_pass_skb_to_rx_hook.patch
> 
> From: Jason Wessel <jason.wessel@windriver.com>
> CC: mpm@selenic.com
> Subject: [PATCH] Pass skb via NET_POLL rx routine
> 
> This patch is a chane to the NET POLL api so that the MAC address or
> IP frame information can be parsed by the driver that wishes to use
> it.  Speficially for kgdboe, it is used to automatically collect the
> MAC address of the GDB host.
> 
> Signed-off-by: Jason Wessel <jason.wessel@windriver.com>

Looks great.

Acked-by: Matt Mackall <mpm@selenic.com>

-- 
Mathematics is the supreme nostalgia of our time.
