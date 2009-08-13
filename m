Return-Path: <linux-kernel-owner+w=401wt.eu-S1752009AbZHMETH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752009AbZHMETH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 00:19:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751723AbZHMETG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 00:19:06 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43277
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751576AbZHMETE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 00:19:04 -0400
Date: Wed, 12 Aug 2009 21:19:14 -0700 (PDT)
Message-Id: <20090812.211914.14779651.davem@davemloft.net>
To: julia@diku.dk
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] drivres/net: Change constant name
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0908080953090.25176@ask.diku.dk>
References: <Pine.LNX.4.64.0908080953090.25176@ask.diku.dk>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>
Date: Sat, 8 Aug 2009 09:53:41 +0200 (CEST)

> From: Julia Lawall <julia@diku.dk>
> 
> In this series of tests the constants have the form XRXMAC_STATUS, except
> in this one case.  The values of XRXMAC_STAT_MSK_RXOCTET_CNT_EXP and
> XRXMAC_STATUS_RXOCTET_CNT_EXP are furthermore the same.
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>

Applied.
