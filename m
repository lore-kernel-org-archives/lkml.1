Return-Path: <linux-kernel-owner+w=401wt.eu-S1763451AbYBZSE1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763451AbYBZSE1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 13:04:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760196AbYBZSET
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 13:04:19 -0500
Received: from miranda.se.axis.com ([193.13.178.8]:57784 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760638AbYBZSES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 13:04:18 -0500
Date: Tue, 26 Feb 2008 19:04:02 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: mikael.starvik@axis.com, dev-etrax@axis.com, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch v2] cris: proper defconfig setup
Message-ID: <20080226180402.GH24124@axis.com>
References: <20080226172847.GB8287@cs181133002.pp.htv.fi> <20080226174703.GD8287@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080226174703.GD8287@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2008 at 07:47:03PM +0200, Adrian Bunk wrote:
> This patch moves the cris defconfigs to arch/cris/configs/ where they 
> belong.
> 
> As a side effect they can now be used directly through e.g.
>   make ARCH=cris artpec_3_defconfig
> 
> The default defconfig is set through KBUILD_DEFCONFIG.
> 
> Signed-off-by: Adrian Bunk <adrian.bunk@movial.fi>

> Patch updated after I discovered an additional defconfig in 
> arch/cris/arch-v10/defconfig

That could probably have been nuked, it's ancient.

I'll put this in my queue. Thanks!

/^JN - Jesper Nilsson
--
               Jesper Nilsson -- jesper.nilsson@axis.com
