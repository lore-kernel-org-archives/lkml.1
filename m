Return-Path: <linux-kernel-owner+w=401wt.eu-S1765146AbXGYMSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765146AbXGYMSU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 08:18:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760517AbXGYMSC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 08:18:02 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:50647 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764951AbXGYMSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 08:18:00 -0400
Date: Wed, 25 Jul 2007 13:17:24 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Greg Ungerer <gerg@snapgear.com>
Cc: torvalds@linux-foundation.org, gerg@uclinux.org,
       linux-kernel@vger.kernel.org
Subject: Re: [M68KNOMMU]: create hw_irq.h
Message-ID: <20070725121724.GA4923@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Greg Ungerer <gerg@snapgear.com>, torvalds@linux-foundation.org,
	gerg@uclinux.org, linux-kernel@vger.kernel.org
References: <200707251207.l6PC7KiH032176@goober>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707251207.l6PC7KiH032176@goober>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2007 at 10:07:20PM +1000, Greg Ungerer wrote:
> Need an include/asm-m68knommu/hw_irq.h for kernel/hrtimer.c

hrtimer.c should be fixed not to include it instead.

