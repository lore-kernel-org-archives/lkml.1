Return-Path: <linux-kernel-owner+w=401wt.eu-S1758285AbYJIAo0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758285AbYJIAo0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 20:44:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757859AbYJIAmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 20:42:55 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59324
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757850AbYJIAmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 20:42:54 -0400
Date: Wed, 08 Oct 2008 17:42:30 -0700 (PDT)
Message-Id: <20081008.174230.11505932.davem@davemloft.net>
To: divy@chelsio.com
Cc: jeff@garzik.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Subject: Re: [PATCH 5/8 2.6.28] cxgb3 - More flexible support for PHY
 interrupts.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081009003418.13412.75569.stgit@speedy5>
References: <20081009003418.13412.75569.stgit@speedy5>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Divy Le Ray <divy@chelsio.com>
Date: Wed, 08 Oct 2008 17:34:19 -0700

> Do not require PHY interrupts to be connected to GPIs in ascending order.
> Base interrupt availability both on PHYs supporting them and on GPIs being
> hooked up.  Allows boards to specify interrupt GPIs though the PHYs don't
> use them.
> Remove spurious PHY interrupts due to clearing T3DBG interrupts before
> setting their polarity.
> 
> Signed-off-by: Divy Le Ray <divy@chelsio.com>

Applied.
