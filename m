Return-Path: <linux-kernel-owner+w=401wt.eu-S932372AbXBWN6H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932372AbXBWN6H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 08:58:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932374AbXBWN6H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 08:58:07 -0500
Received: from stout.engsoc.carleton.ca ([134.117.69.22]:39725 "EHLO
	stout.engsoc.carleton.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932372AbXBWN6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 08:58:05 -0500
Date: Fri, 23 Feb 2007 08:57:41 -0500
From: Kyle McMartin <kyle@parisc-linux.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: "John W. Linville" <linville@tuxdriver.com>, linux-kernel@vger.kernel.org,
       James.Bottomley@SteelEye.com, Tejun Heo <htejun@gmail.com>,
       Jeff Garzik <jeff@garzik.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH] dma-mapping-broken.h: flesh-out DMA API stubs
Message-ID: <20070223135740.GA28270@athena.road.mcmartin.ca>
References: <20070223005945.GA13084@tuxdriver.com> <20070223034243.GA7988@osiris.ibm.com> <20070223061332.GB27126@osiris.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070223061332.GB27126@osiris.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 23, 2007 at 07:13:32AM +0100, Heiko Carstens wrote:
> How about this for telling that an architecture doesn't support DMA?
> At least we could get rid of dma-mapping-broken.h and don't need to
> compile some afterwards dead code.
> 
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>

This like a lot better of an idea than stubbing out things which should never
be built in the first place...

Cheers,
	Kyle
