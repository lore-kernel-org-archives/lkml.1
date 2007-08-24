Return-Path: <linux-kernel-owner+w=401wt.eu-S1765993AbXHXHXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765993AbXHXHXW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 03:23:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754956AbXHXHXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 03:23:10 -0400
Received: from gate.crashing.org ([63.228.1.57]:32931 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754714AbXHXHXJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 03:23:09 -0400
In-Reply-To: <c4e095af9df5ab47e7d1c8e4f3d256d74576a0c9.1187912217.git.jesper.juhl@gmail.com>
References: <1554af80879a7ef2f78a4d654f23c248203500d9.1187912217.git.jesper.juhl@gmail.com> <c4e095af9df5ab47e7d1c8e4f3d256d74576a0c9.1187912217.git.jesper.juhl@gmail.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <4F41C3E8-49C1-4F5A-ABB3-116853C5102C@kernel.crashing.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
       Andy Fleming <afleming@freescale.com>
Content-Transfer-Encoding: 7bit
From: Kumar Gala <galak@kernel.crashing.org>
Subject: Re: [PATCH 12/30] net: No point in casting kmalloc return values in Gianfar Ethernet Driver
Date: Fri, 24 Aug 2007 02:25:09 -0500
To: Jesper Juhl <jesper.juhl@gmail.com>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 23, 2007, at 6:59 PM, Jesper Juhl wrote:

> kmalloc() returns a void ptr, so there's no need to cast its return
> value in drivers/net/gianfar.c .
>
> Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>

Acked-by: Kumar Gala <galak@kernel.crashing.org>

- k
