Return-Path: <linux-kernel-owner+w=401wt.eu-S1752530AbYGXD3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530AbYGXD3q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 23:29:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751415AbYGXD3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 23:29:32 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45329
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751025AbYGXD3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 23:29:31 -0400
Date: Wed, 23 Jul 2008 20:29:31 -0700 (PDT)
Message-Id: <20080723.202931.96993435.davem@davemloft.net>
To: chas@cmf.nrl.navy.mil
Cc: netdev@vger.kernel.org, linux-atm-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, dwmw2@infradead.org
Subject: Re: [Linux-ATM-General] [PATCH] firmware: convert Ambassador ATM
 driver to request_firmware()
From: David Miller <davem@davemloft.net>
In-Reply-To: <200807092037.m69Kbmc0030545@cmf.nrl.navy.mil>
References: <1214853492.10393.350.camel@pmac.infradead.org>
	<200807092037.m69Kbmc0030545@cmf.nrl.navy.mil>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Chas Williams (CONTRACTOR)" <chas@cmf.nrl.navy.mil>
Date: Wed, 09 Jul 2008 16:37:48 -0400

> dave, please apply to net-next.  thanks! 
> 
> Author: Chas Williams - CONTRACTOR <chas@relax.cmf.nrl.navy.mil>
> Date:   Wed Jul 9 12:39:08 2008 -0400
> 
>     atm: [fore200e] use MODULE_FIRMWARE() and other suggested cleanups
>     
>     Signed-off-by: Chas Williams <chas@cmf.nrl.navy.mil>

Applied, thanks Chas.
