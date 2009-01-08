Return-Path: <linux-kernel-owner+w=401wt.eu-S1762244AbZAHT3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762244AbZAHT3k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 14:29:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758138AbZAHT30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 14:29:26 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49937
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755181AbZAHT3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 14:29:25 -0500
Date: Thu, 08 Jan 2009 11:29:27 -0800 (PST)
Message-Id: <20090108.112927.143913755.davem@davemloft.net>
To: vapier.adi@gmail.com
Cc: cooloney@kernel.org, jeff@garzik.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, graf.yang@analog.com
Subject: Re: [PATCH 2/2] netdev: bfin_mac: enable VLAN support in Blackfin
 MAC driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <8bd0f97a0901081101t6fdfa485rbd7ccc4e47691ddb@mail.gmail.com>
References: <1231344879-26069-3-git-send-email-cooloney@kernel.org>
	<20090108.105531.176161465.davem@davemloft.net>
	<8bd0f97a0901081101t6fdfa485rbd7ccc4e47691ddb@mail.gmail.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Mike Frysinger" <vapier.adi@gmail.com>
Date: Thu, 8 Jan 2009 14:01:49 -0500

> > We can get VLAN packets received and sent, using AF_PACKET
> > sockets, for example.  The chip should still respect those
> > even if VLAN proper is not being utilized.
> 
> any tips on doing that ?

No, sorry.
