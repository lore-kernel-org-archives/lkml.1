Return-Path: <linux-kernel-owner+w=401wt.eu-S1754127AbYLMFNP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127AbYLMFNP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 00:13:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750814AbYLMFNG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 00:13:06 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37012
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750745AbYLMFNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 00:13:04 -0500
Date: Fri, 12 Dec 2008 21:13:05 -0800 (PST)
Message-Id: <20081212.211305.162952487.davem@davemloft.net>
To: hannes@hanneseder.net
Cc: netdev@vger.kernel.org, kkeil@suse.de, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/9][v2] mISDN: use NULL pointer instead of plain
 integer
From: David Miller <davem@davemloft.net>
In-Reply-To: <49419a20.07a0660a.4c25.ffff8ce9@mx.google.com>
References: <49419a20.07a0660a.4c25.ffff8ce9@mx.google.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hannes Eder <hannes@hanneseder.net>
Date: Thu, 11 Dec 2008 22:36:00 +0100

> Fix more than 100 (all remaining in mISDN) sparse warnings:
> 
>   drivers/isdn/hardware/mISDN/hfcmulti.c:***:**: warning: Using plain integer as NULL pointer
>   drivers/isdn/mISDN/dsp_tones.c:***:**: warning: Using plain integer as NULL pointer
>   drivers/isdn/mISDN/dsp_pipeline.c:***:**: warning: Using plain integer as NULL pointer
> 
> Signed-off-by: Hannes Eder <hannes@hanneseder.net>
> Acked-by: Karsten Keil <kkeil@suse.de>

Applied.
