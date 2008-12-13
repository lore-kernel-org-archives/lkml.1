Return-Path: <linux-kernel-owner+w=401wt.eu-S1756441AbYLMFRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756441AbYLMFRS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 00:17:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751398AbYLMFRI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 00:17:08 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42645
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750838AbYLMFRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 00:17:07 -0500
Date: Fri, 12 Dec 2008 21:17:08 -0800 (PST)
Message-Id: <20081212.211708.144435933.davem@davemloft.net>
To: hannes@hanneseder.net
Cc: netdev@vger.kernel.org, kkeil@suse.de, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 5/9][v2] mISDN: fix sparse warning: symbol 'nskb'
 shadows an earlier one
From: David Miller <davem@davemloft.net>
In-Reply-To: <49419a31.0aa1660a.486c.07b8@mx.google.com>
References: <49419a31.0aa1660a.486c.07b8@mx.google.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hannes Eder <hannes@hanneseder.net>
Date: Thu, 11 Dec 2008 22:36:00 +0100

> Impact: define first occurence of variable 'nskb' in inner most possible scope
> 
> Fix this sparse warning:
> 
>   drivers/isdn/mISDN/dsp_core.c:746:20: warning: symbol 'nskb' shadows an earlier one
>   drivers/isdn/mISDN/dsp_core.c:634:19: originally declared here
> 
> Signed-off-by: Hannes Eder <hannes@hanneseder.net>
> Acked-by: Karsten Keil <kkeil@suse.de>

Applied.
