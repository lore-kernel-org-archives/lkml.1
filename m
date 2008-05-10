Return-Path: <linux-kernel-owner+w=401wt.eu-S1753293AbYEJHsx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293AbYEJHsx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2008 03:48:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751086AbYEJHso
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 May 2008 03:48:44 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:48197 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070AbYEJHsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2008 03:48:43 -0400
Date: Sat, 10 May 2008 09:48:41 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: David Miller <davem@davemloft.net>
cc: linux-kernel@vger.kernel.org, adaplas@pol.net, hpa@zytor.com,
       alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
Subject: Re: 2.6.26-rcX VC console scrolling regression
In-Reply-To: <20080509.145524.193685795.davem@davemloft.net>
Message-ID: <alpine.LNX.1.10.0805100948290.18486@fbirervta.pbzchgretzou.qr>
References: <alpine.LNX.1.10.0805081236190.16904@fbirervta.pbzchgretzou.qr> <20080508.232602.193723628.davem@davemloft.net> <alpine.LNX.1.10.0805092124010.28042@fbirervta.pbzchgretzou.qr> <20080509.145524.193685795.davem@davemloft.net>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Friday 2008-05-09 23:55, David Miller wrote:
>> >
>> Try this patch please.
>
>That seems to fix the bug, thanks Jan.
>
>Acked-by: David S. Miller <davem@davemloft.net>
>
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
