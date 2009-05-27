Return-Path: <linux-kernel-owner+w=401wt.eu-S1759127AbZE0DtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759127AbZE0DtW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 23:49:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756323AbZE0DtN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 23:49:13 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41001
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755691AbZE0DtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 23:49:12 -0400
Date: Tue, 26 May 2009 20:49:11 -0700 (PDT)
Message-Id: <20090526.204911.75347876.davem@davemloft.net>
To: kexin.hao@windriver.com
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       netdev@vger.kernel.org, leoli@freescale.com
Subject: Re: [PATCH] net/ucc_geth: allow to set mac address on running
 device
From: David Miller <davem@davemloft.net>
In-Reply-To: <1243388936.13410.4.camel@kevin>
References: <1243388936.13410.4.camel@kevin>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kevin Hao <kexin.hao@windriver.com>
Date: Wed, 27 May 2009 09:48:56 +0800

> Inspired by the patch for 8139too (bda6a15a).
> 
> Currently we can't set mac address on a running ucc_geth device.
> But this is needed when you use this device as a bonding slave in
> bonding device in balance-alb mode. So add this feature for ucc_geth
> device.
> 
> Signed-off-by: Kevin Hao <kexin.hao@windriver.com>

Applied to net-next-2.6, thanks.
