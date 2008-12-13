Return-Path: <linux-kernel-owner+w=401wt.eu-S1756593AbYLMFRz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756593AbYLMFRz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 00:17:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752081AbYLMFRq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 00:17:46 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42648
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750935AbYLMFRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 00:17:45 -0500
Date: Fri, 12 Dec 2008 21:17:46 -0800 (PST)
Message-Id: <20081212.211746.16355480.davem@davemloft.net>
To: hannes@hanneseder.net
Cc: netdev@vger.kernel.org, kkeil@suse.de, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 6/9][v2] mISDN: fix sparse warning: symbol 'id' shadows
 an earlier one
From: David Miller <davem@davemloft.net>
In-Reply-To: <49419a37.0aa5660a.7d74.31a0@mx.google.com>
References: <49419a37.0aa5660a.7d74.31a0@mx.google.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hannes Eder <hannes@hanneseder.net>
Date: Thu, 11 Dec 2008 22:36:00 +0100

> Impact: rename function scope variable
> 
> Fix this warning:
> 
>   drivers/isdn/mISDN/l1oip_core.c:472:8: warning: symbol 'id' shadows an earlier one
>   drivers/isdn/mISDN/l1oip_core.c:254:14: originally declared here
> 
> Signed-off-by: Hannes Eder <hannes@hanneseder.net>
> Acked-by: Karsten Keil <kkeil@suse.de>

Applied.
