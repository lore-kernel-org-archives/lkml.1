Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755700Ab0CHUPU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 15:15:20 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36395
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755640Ab0CHUPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 15:15:16 -0500
Date: Mon, 08 Mar 2010 12:15:35 -0800 (PST)
Message-Id: <20100308.121535.125570089.davem@davemloft.net>
To: joe@perches.com
Cc: Trond.Myklebust@netapp.com, linux-nfs@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH resend] net/sunrpc: Remove uses of NIPQUAD, use %pI4
From: David Miller <davem@davemloft.net>
In-Reply-To: <1267857980.849.22.camel@Joe-Laptop.home>
References: <1267857980.849.22.camel@Joe-Laptop.home>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Fri, 05 Mar 2010 22:46:20 -0800

> Originally submitted Jan 1, 2010
> http://patchwork.kernel.org/patch/71221/
> 
> Convert NIPQUAD to the %pI4 format extension where possible
> Convert %02x%02x%02x%02x/NIPQUAD to %08x/ntohl
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied.
