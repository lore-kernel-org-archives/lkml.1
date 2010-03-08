Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755721Ab0CHUP5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 15:15:57 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36401
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755587Ab0CHUPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 15:15:51 -0500
Date: Mon, 08 Mar 2010 12:16:10 -0800 (PST)
Message-Id: <20100308.121610.51678711.davem@davemloft.net>
To: joe@perches.com
Cc: chuck.lever@oracle.com, Trond.Myklebust@netapp.com,
       linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/sunrpc: Convert (void)snprintf to snprintf
From: David Miller <davem@davemloft.net>
In-Reply-To: <1268066310.1925.26.camel@Joe-Laptop.home>
References: <1267857980.849.22.camel@Joe-Laptop.home>
	<4B951BF0.9050403@oracle.com>
	<1268066310.1925.26.camel@Joe-Laptop.home>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Mon, 08 Mar 2010 08:38:30 -0800

> (Applies on top of "Remove uses of NIPQUAD, use %pI4")
> 
> Casts to void of snprintf are most uncommon in kernel source.
> 9 use casts, 1301 do not.
> 
> Remove the remaining uses in net/sunrpc/
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Also applied, thanks Joe.
