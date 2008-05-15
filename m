Return-Path: <linux-kernel-owner+w=401wt.eu-S1762730AbYEOVcN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762730AbYEOVcN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 17:32:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752987AbYEOVb4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 17:31:56 -0400
Received: from smtp4.int-evry.fr ([157.159.10.71]:48064 "EHLO
	smtp4.int-evry.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363AbYEOVbz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 17:31:55 -0400
From: Florian Fainelli <florian.fainelli@telecomint.eu>
To: "Christophe Jaillet" <christophe.jaillet@wanadoo.fr>,
       Francois Romieu <romieu@fr.zoreil.com>
Subject: Re: [PATCH 1/1] /drivers/net/r6040.c: bad use of round_jiffies() ???
Date: Thu, 15 May 2008 23:31:37 +0200
User-Agent: KMail/1.9.9
Cc: "linux" <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
References: <20080515212624.D56371C00093@mwinf2723.orange.fr>
In-Reply-To: <20080515212624.D56371C00093@mwinf2723.orange.fr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200805152331.37500.florian.fainelli@telecomint.eu>
X-INT-MailScanner-Information: Please contact the ISP for more information
X-MailScanner-ID: 859E53ED602.2E37D
X-INT-MailScanner: Found to be clean
X-INT-MailScanner-SpamCheck: 
X-INT-MailScanner-From: florian.fainelli@telecomint.eu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Christophe,

Le Thursday 15 May 2008 23:26:22 Christophe Jaillet, vous avez écrit :
> From: Christophe Jaillet <christophe.jaillet@wanadoo.fr>
>
> Hi, here is a patch against linux/drivers/net/r6040.c.
>
> Compared to other places in the kernel, I think that this driver misuses
> the function round_jiffies.

You are right, thanks for this fix.

> Signed-off-by: Christophe Jaillet <christophe.jaillet@wanadoo.fr>

Acked-by: Florian Fainelli <florian.fainelli@telecomint.eu>
