Return-Path: <linux-kernel-owner+w=401wt.eu-S1755915AbYKZXft@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755915AbYKZXft (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 18:35:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752713AbYKZXfg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 18:35:36 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44433
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752532AbYKZXff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 18:35:35 -0500
Date: Wed, 26 Nov 2008 15:35:35 -0800 (PST)
Message-Id: <20081126.153535.216159302.davem@davemloft.net>
To: divy@chelsio.com
Cc: jeff@garzik.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Subject: Re: [PATCH 1/4 2.6.29] cxgb3 - set hard_xmit in the netdev_ops
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081126203814.4786.93917.stgit@speedy5>
References: <20081126203814.4786.93917.stgit@speedy5>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Divy Le Ray <divy@chelsio.com>
Date: Wed, 26 Nov 2008 12:38:14 -0800

> From: Divy Le Ray <divy@chelsio.com>
> 
> Fix t3_eth_xmit() missing into the netdev_ops structure.
> 
> Signed-off-by: Divy Le Ray <divy@chelsio.com>

Applied.
