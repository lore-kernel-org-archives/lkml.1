Return-Path: <linux-kernel-owner+w=401wt.eu-S1753009Ab0AKXHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753009Ab0AKXHS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 18:07:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751713Ab0AKXHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 18:07:16 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49660
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752629Ab0AKXHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 18:07:15 -0500
Date: Mon, 11 Jan 2010 15:07:24 -0800 (PST)
Message-Id: <20100111.150724.137578397.davem@davemloft.net>
To: jarkao2@gmail.com
Cc: mbreuer@majjas.com, shemminger@vyatta.com, akpm@linux-foundation.org,
       flyboy@gmail.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-2.6 alt.3] af_packet: Don't use skb after
 dev_queue_xmit()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100111224817.GB3369@del.dom.local>
References: <20100111080419.GA6061@ff.dom.local>
	<4B4BA695.7040803@majjas.com>
	<20100111224817.GB3369@del.dom.local>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jarek Poplawski <jarkao2@gmail.com>
Date: Mon, 11 Jan 2010 23:48:17 +0100

> David, if this patch is acceptable now, please add:
> 
> With help from: David S. Miller <davem@davemloft.net>
> 
> Tested-by: Michael Breuer<mbreuer@majjas.com>

Okie dokie, I plan to look over this stuff later today.
