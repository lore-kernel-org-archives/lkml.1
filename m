Return-Path: <linux-kernel-owner+w=401wt.eu-S1763635AbYBZRxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763635AbYBZRxS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 12:53:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761123AbYBZRxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 12:53:10 -0500
Received: from miranda.se.axis.com ([193.13.178.8]:56914 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761394AbYBZRxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 12:53:09 -0500
Date: Tue, 26 Feb 2008 18:53:03 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Adrian Bunk <adrian.bunk@movial.fi>
Cc: mikael.starvik@axis.com, dev-etrax@axis.com, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] cris: proper defconfig setup
Message-ID: <20080226175303.GG24124@axis.com>
References: <20080226172847.GB8287@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080226172847.GB8287@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2008 at 07:28:47PM +0200, Adrian Bunk wrote:
> This patch moves the cris defconfigs to arch/cris/configs/ where they 
> belong.
> 
> As a side effect they can now directly be used through e.g.
>   make ARCH=cris artpec_3_defconfig
> 
> The default defconfig is set through KBUILD_DEFCONFIG.
> 
> Signed-off-by: Adrian Bunk <adrian.bunk@movial.fi>

Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>

Thanks!

/^JN - Jesper Nilsson
--
               Jesper Nilsson -- jesper.nilsson@axis.com
