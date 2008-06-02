Return-Path: <linux-kernel-owner+w=401wt.eu-S1757575AbYFBGmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757575AbYFBGmp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 02:42:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751723AbYFBGmf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 02:42:35 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48495
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750788AbYFBGme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 02:42:34 -0400
Date: Sun, 01 Jun 2008 23:42:30 -0700 (PDT)
Message-Id: <20080601.234230.201092564.davem@davemloft.net>
To: ramirose@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net-2.6 0/2] [IPV4] [NETFILTER] Misc Cleanups.
From: David Miller <davem@davemloft.net>
In-Reply-To: <eb3ff54b0806012336s687b0d89t767c31615d955c61@mail.gmail.com>
References: <eb3ff54b0806012336s687b0d89t767c31615d955c61@mail.gmail.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Rami Rosen" <ramirose@gmail.com>
Date: Mon, 2 Jun 2008 09:36:35 +0300

Adding netfilter-devel to CC:, please do this for future netfilter
patch submissions.

>   While probing into IPV4 netfilter code, I came across these cleanups in
>   net/ipv4/netfilter/ip_queue.c and in
> include/net/netfilter/ipv4/nf_conntrack_ipv4.h.
> 
> Regards,
> Rami Rosen
> 
> 
> Signed-off-by: Rami Rosen <ramirose@gmail.com>
