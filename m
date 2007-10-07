Return-Path: <linux-kernel-owner+w=401wt.eu-S1756933AbXJGUKu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756933AbXJGUKu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 16:10:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755641AbXJGUKn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 16:10:43 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:35342 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755406AbXJGUKm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 16:10:42 -0400
Date: Mon, 8 Oct 2007 05:10:24 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Adrian McMenamin <lkmladrian@gmail.com>
Cc: linux-kernel@vger.kernel.org, linuxsh-dev@sourceforge.net
Subject: Re: [PATCH] Fix SH4 DMAC API
Message-ID: <20071007201024.GB17760@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Adrian McMenamin <lkmladrian@gmail.com>,
	linux-kernel@vger.kernel.org, linuxsh-dev@sourceforge.net
References: <8b67d60710060652ha54d28bj30bdc9eec514857f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8b67d60710060652ha54d28bj30bdc9eec514857f@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 06, 2007 at 02:52:43PM +0100, Adrian McMenamin wrote:
> This patch fixes the DMA cascade by masking the correct bits.
> 
> Tested and working with Dreamcast PVR2 DMA. With this patch applied
> the existing mainline code in arch/sh/drivers/dma/dma-sh.c works,
> whereas before I was patching that to get round this problem.
> 
> Signed-off by: Adrian McMenamin <adrian@mcmen.demon.co.uk>
> 
Applied, thanks.
