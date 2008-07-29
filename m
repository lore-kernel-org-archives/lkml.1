Return-Path: <linux-kernel-owner+w=401wt.eu-S1754957AbYG2B3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754957AbYG2B3z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 21:29:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751632AbYG2B3r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 21:29:47 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:35069 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146AbYG2B3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 21:29:47 -0400
Date: Mon, 28 Jul 2008 19:29:46 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [git pull] PCI code for 2.6.27-rc1
Message-ID: <20080729012945.GA28989@parisc-linux.org>
References: <200807281750.14142.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807281750.14142.jbarnes@virtuousgeek.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2008 at 05:50:14PM -0700, Jesse Barnes wrote:
> Dmitry Baryshkov (7):
>       generic: per-device coherent dma allocator
>       x86: use generic per-device dma coherent allocator
>       Generic dma-coherent: fix DMA_MEMORY_EXCLUSIVE
>       ARM: support generic per-device coherent dma mem
>       Sh: use generic per-device coherent dma allocator
>       Cris: convert to using generic dma-coherent mem allocator
>       dma-coherent: add documentation to new interfaces

Were these patches posted to linux-pci?  I don't think I ever saw them.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
