Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756812Ab0BLPBz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 10:01:55 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:51961 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943Ab0BLPBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 10:01:54 -0500
Date: Fri, 12 Feb 2010 15:01:45 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH -mm 6/7] arm: use generic pci_set_dma_mask and
	pci_set_consistent_dma_mask
Message-ID: <20100212150145.GD18595@n2100.arm.linux.org.uk>
References: <1265967212-9126-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1265967212-9126-7-git-send-email-fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1265967212-9126-7-git-send-email-fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 12, 2010 at 06:33:31PM +0900, FUJITA Tomonori wrote:
> This converts arm to the generic pci_set_dma_mask and
> pci_set_consistent_dma_mask (removes HAVE_ARCH_PCI_SET_DMA_MASK for
> dmabounce).
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Cc: Russell King <linux@arm.linux.org.uk>

This looks like it's right; I don't have any way to test it though
since I don't have the hardware.

Therefore, I'll just give it:

Looked-over-by: Russell King <rmk+kernel@arm.linux.org.uk>

since I don't think it warrants Reviewed-by nor Acked-by from me.
