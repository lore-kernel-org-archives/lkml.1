Return-Path: <linux-kernel-owner+w=401wt.eu-S1752613AbXCMACz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613AbXCMACz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 20:02:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752424AbXCMACz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 20:02:55 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53611
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752613AbXCMACy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 20:02:54 -0400
Date: Mon, 12 Mar 2007 17:02:53 -0700 (PDT)
Message-Id: <20070312.170253.122618823.davem@davemloft.net>
To: Geert.Uytterhoeven@sonycom.com
Cc: jeff@garzik.org, fubar@us.ibm.com, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [git patches] net driver fixes
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.62.0703121100260.16343@pademelon.sonytel.be>
References: <20070306114808.GA22724@havoc.gtf.org>
	<Pine.LNX.4.62.0703121100260.16343@pademelon.sonytel.be>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Date: Mon, 12 Mar 2007 11:02:43 +0100 (CET)

> On Tue, 6 Mar 2007, Jeff Garzik wrote:
> > Jay Vosburgh (3):
> >       bonding: Improve IGMP join processing
> 
> ip_mc_rejoin_group: Kill warning about unused variable `in_dev' when
> CONFIG_IP_MULTICAST is not set.
> 
> Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

Applied, thanks Geert.
