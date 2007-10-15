Return-Path: <linux-kernel-owner+w=401wt.eu-S933466AbXJOT6A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933466AbXJOT6A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 15:58:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933873AbXJOT5q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 15:57:46 -0400
Received: from waste.org ([66.93.16.53]:49833 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933867AbXJOT5p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 15:57:45 -0400
Date: Mon, 15 Oct 2007 14:57:41 -0500
From: Matt Mackall <mpm@selenic.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/21] KGDB: This is the simple KGDB over Ethernet I/O driver that NET_POLL
Message-ID: <20071015195741.GV19691@waste.org>
References: <4713B255.5010708@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4713B255.5010708@windriver.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2007 at 01:32:53PM -0500, Jason Wessel wrote:
> Signed-off-by: Jason Wessel <jason.wessel@windriver.com>

> eth.patch
> 
> From: Jason Wessel <jason.wessel@windriver.com>
> CC: mpm@selenic.com
> Subject: [PATCH] This is the simple KGDB over Ethernet I/O driver that NET_POLL
> 
> At one point this was very similar to the version Matt Mackall wrote
> to allow for the use of KGDB over ethernet.  Since then it has been
> reworked to fit into the unified KGDB model.
> 
> Signed-off-by: Tom Rini <trini@kernel.crashing.org>
> Signed-off-by: Jason Wessel <jason.wessel@windriver.com>

Looks fine to me.

Acked-by: Matt Mackall <mpm@selenic.com>

-- 
Mathematics is the supreme nostalgia of our time.
