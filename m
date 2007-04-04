Return-Path: <linux-kernel-owner+w=401wt.eu-S2992848AbXDDLmA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992848AbXDDLmA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 07:42:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992866AbXDDLmA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 07:42:00 -0400
Received: from pollux.ds.pg.gda.pl ([153.19.208.7]:2480 "EHLO
	pollux.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992848AbXDDLl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 07:41:59 -0400
Date: Wed, 4 Apr 2007 12:41:55 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
cc: Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mips <linux-mips@linux-mips.org>
Subject: Re: [PATCH] Fixed build error on zs serial driver
In-Reply-To: <20070404162934.2635ef95.yoichi_yuasa@tripeaks.co.jp>
Message-ID: <Pine.LNX.4.64N.0704041240410.19559@blysk.ds.pg.gda.pl>
References: <20070404162934.2635ef95.yoichi_yuasa@tripeaks.co.jp>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Apr 2007, Yoichi Yuasa wrote:

> This patch has fixed build error on zs serial driver.
> 
> drivers/tc/zs.c:73:24: error: asm/dec/tc.h: No such file or directory
> make[2]: *** [drivers/tc/zs.o] Error 1
> 
> Yoichi
> 
> Signed-off-by: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>

Acked-by: Maciej W. Rozycki <macro@linux-mips.org>

 The driver is on its way out though.

  Maciej
