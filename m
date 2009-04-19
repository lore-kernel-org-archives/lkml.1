Return-Path: <linux-kernel-owner+w=401wt.eu-S1754207AbZDSEY1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207AbZDSEY1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 00:24:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751013AbZDSEYT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 00:24:19 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40309
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750777AbZDSEYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 00:24:19 -0400
Date: Sat, 18 Apr 2009 21:24:11 -0700 (PDT)
Message-Id: <20090418.212411.72350276.davem@davemloft.net>
To: g.liakhovetski@gmx.de
Cc: florian@openwrt.org, peter@holik.at, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb driver for intellon based PLC like devolo dlan duo
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090418.211503.13481677.davem@davemloft.net>
References: <20090418.015541.05303908.davem@davemloft.net>
	<Pine.LNX.4.64.0904182146220.14879@axis700.grange>
	<20090418.211503.13481677.davem@davemloft.net>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Sat, 18 Apr 2009 21:15:03 -0700 (PDT)

> This extends to other driver's I've written.  The niu driver thus
> uses "tr64()" and "nw64()".
        ^^^^^

Typo, meant "nr64()" of course :)

