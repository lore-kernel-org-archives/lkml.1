Return-Path: <linux-kernel-owner+w=401wt.eu-S1757212AbYFXIzI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757212AbYFXIzI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 04:55:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750732AbYFXIyv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 04:54:51 -0400
Received: from smtp4.int-evry.fr ([157.159.10.71]:47848 "EHLO
	smtp4.int-evry.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713AbYFXIyu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 04:54:50 -0400
From: Florian Fainelli <florian.fainelli@telecomint.eu>
To: Julia Lawall <julia@diku.dk>
Subject: Re: [PATCH] drivers/net/r6040.c: Eliminate double sizeof
Date: Tue, 24 Jun 2008 10:54:18 +0200
User-Agent: KMail/1.9.9
Cc: jgarzik@pobox.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
References: <Pine.LNX.4.64.0806232311570.13402@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.0806232311570.13402@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200806241054.19392.florian.fainelli@telecomint.eu>
X-INT-MailScanner-Information: Please contact the ISP for more information
X-MailScanner-ID: A0A453ED3C7.AC88F
X-INT-MailScanner: Found to be clean
X-INT-MailScanner-SpamCheck: 
X-INT-MailScanner-From: florian.fainelli@telecomint.eu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Julia,

Le Monday 23 June 2008 23:12:31 Julia Lawall, vous avez écrit :
> From: Julia Lawall <julia@diku.dk>
>
> Taking sizeof the result of sizeof is quite strange and does not seem to be
> what is wanted here.

Yes, definitively.

> Signed-off-by: Julia Lawall <julia@diku.dk>

Acked-by: Florian Fainelli <florian.fainelli@telecomint.eu>
-- 
Cordialement, Florian Fainelli
------------------------------
