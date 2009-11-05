Return-Path: <linux-kernel-owner+w=401wt.eu-S1756040AbZKEGFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040AbZKEGFA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 01:05:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755110AbZKEGE7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 01:04:59 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59184
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751252AbZKEGE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 01:04:58 -0500
Date: Wed, 04 Nov 2009 22:05:24 -0800 (PST)
Message-Id: <20091104.220524.156001126.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next-2.6] net: net/ipv4/devinet.c cleanups
From: David Miller <davem@davemloft.net>
In-Reply-To: <4AF2571C.7040700@gmail.com>
References: <20091105133041.a2aa30f7.sfr@canb.auug.org.au>
	<4AF2571C.7040700@gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Thu, 05 Nov 2009 05:39:56 +0100

> [PATCH net-next-2.6] net: net/ipv4/devinet.c cleanups
> 
> As pointed by Stephen Rothwell, commit c6d14c84 added a warning :
> 
> net/ipv4/devinet.c: In function 'inet_select_addr':
> net/ipv4/devinet.c:902: warning: label 'out' defined but not used
> 
> delete unused 'out' label and do some cleanups as well
> 
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>

Applied, thanks everyone.
