Return-Path: <linux-kernel-owner+w=401wt.eu-S1753980AbZHFD3O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980AbZHFD3O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 23:29:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753847AbZHFD3O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 23:29:14 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57287
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753305AbZHFD3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 23:29:13 -0400
Date: Wed, 05 Aug 2009 20:29:22 -0700 (PDT)
Message-Id: <20090805.202922.241102337.davem@davemloft.net>
To: daniel@caiaq.de
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       steve.glendinning@smsc.com, netdev@vger.kernel.org
Subject: Re: [PATCH 5/5] net: smsc911x: switch to new dev_pm_ops
From: David Miller <davem@davemloft.net>
In-Reply-To: <1249496971-9019-5-git-send-email-daniel@caiaq.de>
References: <1249496971-9019-3-git-send-email-daniel@caiaq.de>
	<1249496971-9019-4-git-send-email-daniel@caiaq.de>
	<1249496971-9019-5-git-send-email-daniel@caiaq.de>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Mack <daniel@caiaq.de>
Date: Wed,  5 Aug 2009 20:29:31 +0200

> Hibernation is unsupported for now, which meets the actual
> implementation in the driver. For free/thaw, the chip's D2 state should
> be entered.
> 
> Signed-off-by: Daniel Mack <daniel@caiaq.de>

Steve, if it looks good to you I can toss this into net-next-2.6

Just let me know.
