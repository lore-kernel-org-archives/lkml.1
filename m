Return-Path: <linux-kernel-owner+w=401wt.eu-S1758120AbYJIAnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758120AbYJIAnr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 20:43:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757276AbYJIAmf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 20:42:35 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59312
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757241AbYJIAme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 20:42:34 -0400
Date: Wed, 08 Oct 2008 17:42:10 -0700 (PDT)
Message-Id: <20081008.174210.27526334.davem@davemloft.net>
To: divy@chelsio.com
Cc: jeff@garzik.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Subject: Re: [PATCH 3/8 2.6.28] cxgb3 - allow for PHY reset status
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081009003407.13347.1075.stgit@speedy5>
References: <20081009003407.13347.1075.stgit@speedy5>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Divy Le Ray <divy@chelsio.com>
Date: Wed, 08 Oct 2008 17:34:08 -0700

> First step towards overall PHY layering re-organization.
> Allow a status return when a PHY is reset.
> 
> Signed-off-by: Divy Le Ray <divy@chelsio.com>

Applied.
