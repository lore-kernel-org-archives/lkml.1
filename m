Return-Path: <linux-kernel-owner+w=401wt.eu-S1753752AbYFLCv3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752AbYFLCv3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 22:51:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755516AbYFLCvB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 22:51:01 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:45526 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755481AbYFLCuw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 22:50:52 -0400
Message-ID: <48508F08.7040009@garzik.org>
Date: Wed, 11 Jun 2008 22:50:48 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Christophe Jaillet <christophe.jaillet@wanadoo.fr>
CC: linux <linux-kernel@vger.kernel.org>, florian.fainelli@telecomint.eu,
       netdev@vger.kernel.org
Subject: Re: [PATCH 1/1] /drivers/net/r6040.c: bad use of round_jiffies()
 ???
References: <20080515212624.D56371C00093@mwinf2723.orange.fr>
In-Reply-To: <20080515212624.D56371C00093@mwinf2723.orange.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christophe Jaillet wrote:
> From: Christophe Jaillet <christophe.jaillet@wanadoo.fr>
> 
> Hi, here is a patch against linux/drivers/net/r6040.c.
> 
> Compared to other places in the kernel, I think that this driver misuses
> the function round_jiffies.
> 
> 
> Note: this patch is based on 'linux-2.6.25.tar.bz2'
> 
> Signed-off-by: Christophe Jaillet <christophe.jaillet@wanadoo.fr>

applied



