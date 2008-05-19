Return-Path: <linux-kernel-owner+w=401wt.eu-S1763101AbYESVHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763101AbYESVHa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 17:07:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760129AbYESVHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 17:07:13 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58030
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755902AbYESVHM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 17:07:12 -0400
Date: Mon, 19 May 2008 14:07:07 -0700 (PDT)
Message-Id: <20080519.140707.262584018.davem@davemloft.net>
To: khc@pm.waw.pl
Cc: jeff@garzik.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] WAN: protect Cisco HDLC state changes with a spinlock.
From: David Miller <davem@davemloft.net>
In-Reply-To: <m3od72gqxf.fsf@maximus.localdomain>
References: <m3od72gqxf.fsf@maximus.localdomain>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Mon, 19 May 2008 19:11:08 +0200

> WAN: protect Cisco HDLC state changes with a spinlock.
>     
> Signed-off-by: Krzysztof Ha³asa <khc@pm.waw.pl>

Acked-by: David S. Miller <davem@davemloft.net>
