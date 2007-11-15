Return-Path: <linux-kernel-owner+w=401wt.eu-S933154AbXKOXGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933154AbXKOXGz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 18:06:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764414AbXKOXGo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 18:06:44 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58431
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1764380AbXKOXGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 18:06:43 -0500
Date: Thu, 15 Nov 2007 15:06:42 -0800 (PST)
Message-Id: <20071115.150642.23394673.davem@davemloft.net>
To: divy@chelsio.com
Cc: jeff@garzik.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] chelsio - Fix skb->dev setting
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071115113857.10170.87392.stgit@speedy5>
References: <20071115113857.10170.87392.stgit@speedy5>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Divy Le Ray <divy@chelsio.com>
Date: Thu, 15 Nov 2007 03:38:57 -0800

> From: Divy Le Ray <divy@chelsio.com>
> 
> eth_type_trans() now sets skb->dev. 
> Access skb->def after it gets set.
> 
> Signed-off-by: Divy Le Ray <divy@chelsio.com>

Patch applied, thanks.
