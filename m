Return-Path: <linux-kernel-owner+w=401wt.eu-S1762119AbYGOCkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762119AbYGOCkh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 22:40:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761113AbYGOCgf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 22:36:35 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56261
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1761690AbYGOCge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 22:36:34 -0400
Date: Mon, 14 Jul 2008 19:36:34 -0700 (PDT)
Message-Id: <20080714.193634.207900782.davem@davemloft.net>
To: jeff@garzik.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [git patch] net driver fix for .26
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080711140952.GA17593@havoc.gtf.org>
References: <20080711140952.GA17593@havoc.gtf.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Garzik <jeff@garzik.org>
Date: Fri, 11 Jul 2008 10:09:52 -0400

> 
> Please pull from 'davem-fixes' branch of
> master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git davem-fixes
> 
> to receive the following updates:
> 
>  drivers/net/arm/ixp4xx_eth.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> Krzysztof Halasa (1):
>       ARM: IXP4xx Ethernet NAPI fix

Pulled, thanks Jeff.

This obviously didn't make it into 2.6.26, but if you think
it's relevant let me know and I'll queue it to -stable.
