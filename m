Return-Path: <linux-kernel-owner+w=401wt.eu-S1762450AbYESVGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762450AbYESVGf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 17:06:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755902AbYESVGY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 17:06:24 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58024
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754143AbYESVGY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 17:06:24 -0400
Date: Mon, 19 May 2008 14:06:19 -0700 (PDT)
Message-Id: <20080519.140619.99364727.davem@davemloft.net>
To: khc@pm.waw.pl
Cc: jeff@garzik.org, alan@lxorguk.ukuu.org.uk, paulkf@microgate.com,
       jchapman@katalix.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] WAN: protect HDLC proto list while insmod/rmmod
From: David Miller <davem@davemloft.net>
In-Reply-To: <m3ve1agrek.fsf_-_@maximus.localdomain>
References: <20080512.033244.153113922.davem@davemloft.net>
	<m3lk2djbq3.fsf@maximus.localdomain>
	<m3ve1agrek.fsf_-_@maximus.localdomain>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Mon, 19 May 2008 19:00:51 +0200

> WAN: protect protocol list in hdlc.c with RTNL.
>     
> Signed-off-by: Krzysztof Ha³asa <khc@pm.waw.pl>

Acked-by: David S. Miller <davem@davemloft.net>
