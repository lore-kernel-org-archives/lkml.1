Return-Path: <linux-kernel-owner+w=401wt.eu-S1758670AbXGCAje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758670AbXGCAje (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 20:39:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756845AbXGCAjZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 20:39:25 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:33696 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756405AbXGCAjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 20:39:24 -0400
X-IronPort-AV: i="4.16,489,1175486400"; 
   d="scan'208"; a="44198314:sNHT25531065"
Subject: Re: [PATCH] Blackfin arch: include/asm-blackfin/macros.h die die
	die
From: Bryan Wu <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Marco Roeland <marco.roeland@xs4all.nl>
Cc: Alex Riesen <raa.lkml@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Git Mailing List <git@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20070702150915.GC10400@fiberbit.xs4all.nl>
References: <Pine.LNX.4.64.0707020800010.1972@localhost.localdomain>
	 <4688EF9B.8020405@garzik.org>
	 <9a8748490707020658t5e6542ag6edb435dbc4499ab@mail.gmail.com>
	 <4689073D.1020802@garzik.org>
	 <81b0412b0707020722q25e8eb41t456e7316fe4a7b40@mail.gmail.com>
	 <20070702142926.GB10400@fiberbit.xs4all.nl>
	 <20070702150915.GC10400@fiberbit.xs4all.nl>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Ltd.
Date: Tue, 03 Jul 2007 08:39:19 +0800
Message-Id: <1183423159.10353.10.camel@roc-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-OriginalArrivalTime: 03 Jul 2007 00:39:22.0586 (UTC) FILETIME=[997E43A0:01C7BD0A]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-07-02 at 17:09 +0200, Marco Roeland wrote:
> This file accidentally got truncated instead of deleted in commit df30b11.
> Doing a "make distclean" or "make mrproper" deletes this file because of
> its zero size. Git then sees this as an uncommitted local change.
> 
> Signed-off-by: Marco Roeland <marco.roeland@xs4all.nl>
> ---
>  0 files changed, 0 insertions(+), 0 deletions(-)
>  delete mode 100644 include/asm-blackfin/macros.h
> 
> diff --git a/include/asm-blackfin/macros.h b/include/asm-blackfin/macros.h
> deleted file mode 100644
> index e69de29..0000000

Thanks already in blackfin-2.6.git tree for Linus pull
Acked by: Bryan Wu <bryan.wu@analog.com>
