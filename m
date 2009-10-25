Return-Path: <linux-kernel-owner+w=401wt.eu-S1753149AbZJYJjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149AbZJYJjR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 05:39:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753114AbZJYJjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 05:39:16 -0400
Received: from 1wt.eu ([62.212.114.60]:50499 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752762AbZJYJjQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 05:39:16 -0400
Date: Sun, 25 Oct 2009 10:38:35 +0100
From: Willy Tarreau <w@1wt.eu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: David Miller <davem@davemloft.net>, Francois Romieu <romieu@fr.zoreil.com>,
       Edward Hsu <edward_hsu@realtek.com.tw>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2.4] net: Fix 64 bit DMA addressing for 8139cp and r8169
Message-ID: <20091025093835.GB24476@1wt.eu>
References: <1256187047.3184.2.camel@ht.satnam>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1256187047.3184.2.camel@ht.satnam>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 22, 2009 at 10:20:47AM +0530, Jaswinder Singh Rajput wrote:
> 
> sizeof(dma_addr_t) will be either 4(32 bit) or 8(64 bit)

Merged, thanks Jaswinder.
Willy

