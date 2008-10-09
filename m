Return-Path: <linux-kernel-owner+w=401wt.eu-S1757609AbYJIAon@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757609AbYJIAon (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 20:44:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757298AbYJIAnG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 20:43:06 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59329
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757911AbYJIAnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 20:43:04 -0400
Date: Wed, 08 Oct 2008 17:42:39 -0700 (PDT)
Message-Id: <20081008.174239.55460197.davem@davemloft.net>
To: divy@chelsio.com
Cc: jeff@garzik.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Subject: Re: [PATCH 6/8 2.6.28] cxgb3 - commnonize LASI phy code
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081009003424.13446.70530.stgit@speedy5>
References: <20081009003424.13446.70530.stgit@speedy5>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Divy Le Ray <divy@chelsio.com>
Date: Wed, 08 Oct 2008 17:34:24 -0700

> Add generic code to manage interrupt driven PHYs.
> Do not reset the phy after link parameters update,
> the new values might get lost.
> Return early from link change notification
> when the link parameters remain unchanged.
> 
> Signed-off-by: Divy Le Ray <divy@chelsio.com>

Applied.
