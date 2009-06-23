Return-Path: <linux-kernel-owner+w=401wt.eu-S1760105AbZFWXLx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760105AbZFWXLx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 19:11:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754021AbZFWXLn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 19:11:43 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42460
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752277AbZFWXLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 19:11:42 -0400
Date: Tue, 23 Jun 2009 16:11:47 -0700 (PDT)
Message-Id: <20090623.161147.239832722.davem@davemloft.net>
To: bzolnier@gmail.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/6] ide: add QUANTUM FIREBALLct20 30 with firmware
 APL.090 to ivb_list[]
From: David Miller <davem@davemloft.net>
In-Reply-To: <200906232324.37615.bzolnier@gmail.com>
References: <200906232324.37615.bzolnier@gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date: Tue, 23 Jun 2009 23:24:37 +0200

> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] ide: add QUANTUM FIREBALLct20 30 with firmware APL.090 to ivb_list[]
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
> This disk supports UDMA modes > 2.  According to the old bugreport it needs
> forced cable detection when using 80-wire cable and id dump suggested that
> ivb quirk should be used to fix the problem.  Unfortunately I never received
> any feedback about the patch from the bugreporter.

This one seems pretty safe, applied, thanks!

We'll be on the lookout for bug reports that mention this drive
and revert as needed.
