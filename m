Return-Path: <linux-kernel-owner+w=401wt.eu-S1753565AbZHBTzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565AbZHBTzs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 15:55:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753558AbZHBTzr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 15:55:47 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59205
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753552AbZHBTzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 15:55:44 -0400
Date: Sun, 02 Aug 2009 12:55:52 -0700 (PDT)
Message-Id: <20090802.125552.192054201.davem@davemloft.net>
To: julia@diku.dk
Cc: chas@cmf.nrl.navy.mil, linux-atm-general@lists.sourceforge.net,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 12/15] drivers/atm: Use DIV_ROUND_CLOSEST
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0908021048280.15557@ask.diku.dk>
References: <Pine.LNX.4.64.0908021048280.15557@ask.diku.dk>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>
Date: Sun, 2 Aug 2009 10:48:45 +0200 (CEST)

> From: Julia Lawall <julia@diku.dk>
> 
> The kernel.h macro DIV_ROUND_CLOSEST performs the computation (x + d/2)/d
> but is perhaps more readable.

Applied.
