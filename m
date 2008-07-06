Return-Path: <linux-kernel-owner+w=401wt.eu-S1753471AbYGFEVB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471AbYGFEVB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 00:21:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750835AbYGFEUw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 00:20:52 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36558
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750737AbYGFEUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 00:20:51 -0400
Date: Sat, 05 Jul 2008 21:20:51 -0700 (PDT)
Message-Id: <20080705.212051.82650078.davem@davemloft.net>
To: jeff@garzik.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [git patches] net driver updates for .27
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080705.211029.199316974.davem@davemloft.net>
References: <20080704125446.GA30300@havoc.gtf.org>
	<20080705.211029.199316974.davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Sat, 05 Jul 2008 21:10:29 -0700 (PDT)

> From: Jeff Garzik <jeff@garzik.org>
> Date: Fri, 4 Jul 2008 08:54:46 -0400
> 
> > Please pull from 'davem-next' branch of
> > master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git davem-next
> > 
> > to receive the following updates:
> 
> Pulled and pushed back out ot net-next-2.6, thanks!

BTW, it was super nice to finally see the non-NAPI config
options get obliterated.

For those playing at home, these are the similar turds still
remaining:

AMD8111E_NAPI
ADAPTEC_STARFIRE_NAPI
FORCEDETH_NAPI
VIA_RHINE_NAPI
E1000_NAPI
GFAR_NAPI
UGETH_NAPI
CHELSIO_T1_NAPI
IXGB_NAPI
S2IO_NAPI
TULIP_NAPI
