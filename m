Return-Path: <linux-kernel-owner+w=401wt.eu-S1751824AbYG1Mdg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751824AbYG1Mdg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 08:33:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753407AbYG1MdW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 08:33:22 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39760 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261AbYG1MdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 08:33:21 -0400
Date: Mon, 28 Jul 2008 08:33:09 -0400
From: Christoph Hellwig <hch@infradead.org>
To: David Miller <davem@davemloft.net>
Cc: alan@lxorguk.ukuu.org.uk, sfr@canb.auug.org.au, linuxppc-dev@ozlabs.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, kkeil@suse.de
Subject: Re: [PATCH] isdn: mISDN HFC PCI support depends on virt_to_bus()
Message-ID: <20080728123309.GA3970@infradead.org>
References: <20080728023732.090aff83.sfr@canb.auug.org.au> <20080727182709.1dac0556@lxorguk.ukuu.org.uk> <20080727.125604.73857337.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080727.125604.73857337.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 27, 2008 at 12:56:04PM -0700, David Miller wrote:
> Yes, please.
> 
> IMHO, this driver was really rushed in and that was a huge mistake.
> If it had gone through linux-next we could have tidied all of this
> stuff up in a less "rushed" manner.

Or just reviewed in at least some way..
