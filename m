Return-Path: <linux-kernel-owner+w=401wt.eu-S1754718AbZLBIbr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718AbZLBIbr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 03:31:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754348AbZLBIbq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 03:31:46 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54761
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751689AbZLBIbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 03:31:45 -0500
Date: Wed, 02 Dec 2009 00:31:51 -0800 (PST)
Message-Id: <20091202.003151.77443093.davem@davemloft.net>
To: jie.yang@atheros.com
Cc: ben@decadent.org.uk, 558426@bugs.debian.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next]atl1e:disable NETIF_F_TSO6 for hardware limit
From: David Miller <davem@davemloft.net>
In-Reply-To: <1259723914457-git-send-email-jie.yang@atheros.com>
References: <1259723914457-git-send-email-jie.yang@atheros.com>
X-Mailer: Mew version 6.2 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: <jie.yang@atheros.com>
Date: Wed, 2 Dec 2009 11:18:34 +0800

> From: Jie Yang <jie.yang@atheros.com>
> 
> For hardware limit to support TSOV6, just disable this feature
> Signed-off-by: Jie Yang <jie.yang@atheros.com>

Shouldn't we be applying this to net-2.6 since it's a bug fix?
