Return-Path: <linux-kernel-owner+w=401wt.eu-S1756189AbYG2CJM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189AbYG2CJM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 22:09:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753091AbYG2CI6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 22:08:58 -0400
Received: from outbound-mail-11.bluehost.com ([69.89.18.111]:51133 "HELO
	outbound-mail-11.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752024AbYG2CI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 22:08:57 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=U6XNYmSRhiEcyucJ2j1xlZJf036kqR+3vR1akdnD/OAE9IEi3CQcc1HzVpJ6B2hx20LXJm+femmxRii/x4QBu7mYq1Ryq1ovknPCoNFxwu9it02WK5lfIdXWABMHy8vy;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [git pull] PCI code for 2.6.27-rc1
Date: Mon, 28 Jul 2008 19:08:51 -0700
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
References: <200807281750.14142.jbarnes@virtuousgeek.org> <20080729012945.GA28989@parisc-linux.org>
In-Reply-To: <20080729012945.GA28989@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807281908.51780.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, July 28, 2008 6:29 pm Matthew Wilcox wrote:
> On Mon, Jul 28, 2008 at 05:50:14PM -0700, Jesse Barnes wrote:
> > Dmitry Baryshkov (7):
> >       generic: per-device coherent dma allocator
> >       x86: use generic per-device dma coherent allocator
> >       Generic dma-coherent: fix DMA_MEMORY_EXCLUSIVE
> >       ARM: support generic per-device coherent dma mem
> >       Sh: use generic per-device coherent dma allocator
> >       Cris: convert to using generic dma-coherent mem allocator
> >       dma-coherent: add documentation to new interfaces
>
> Were these patches posted to linux-pci?  I don't think I ever saw them.

No, but they're not really PCI specific patches.  They did go to lkml several 
times and have been sitting in one of Ingo's test trees for awhile.  There 
are no outstanding complaints that I'm aware of.

Jesse
