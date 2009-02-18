Return-Path: <linux-kernel-owner+w=401wt.eu-S1756477AbZBRBYw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756477AbZBRBYw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 20:24:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755516AbZBRBWd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 20:22:33 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47836
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755503AbZBRBWc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 20:22:32 -0500
Date: Tue, 17 Feb 2009 17:22:16 -0800 (PST)
Message-Id: <20090217.172216.152466500.davem@davemloft.net>
To: florian@openwrt.org
Cc: hannes@hanneseder.net, netdev@vger.kernel.org,
       kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/43] drivers/net/r6040.c: fix sparse warning: Using
 plain integer as NULL pointer
From: David Miller <davem@davemloft.net>
In-Reply-To: <200902151500.06516.florian@openwrt.org>
References: <20090214210940.23489.95001.stgit@vmbox.hanneseder.net>
	<20090214211400.23489.24726.stgit@vmbox.hanneseder.net>
	<200902151500.06516.florian@openwrt.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Florian Fainelli <florian@openwrt.org>
Date: Sun, 15 Feb 2009 15:00:06 +0100

> Hello Hannes,
> 
> Le Saturday 14 February 2009 22:14:04 Hannes Eder, vous avez écrit :
> > Fix this sparse warnings:
> >   drivers/net/r6040.c:487:31: warning: Using plain integer as NULL pointer
> >   drivers/net/r6040.c:492:31: warning: Using plain integer as NULL pointer
> 
> Good catch, thanks.
> >
> > Signed-off-by: Hannes Eder <hannes@hanneseder.net>
> 
> Acked-by: Florian Fainelli <florian@openwrt.org>

Applied.
