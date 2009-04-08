Return-Path: <linux-kernel-owner+w=401wt.eu-S1761981AbZDHJJn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761981AbZDHJJn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 05:09:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753655AbZDHJJa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 05:09:30 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38576
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753306AbZDHJJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 05:09:29 -0400
Date: Wed, 08 Apr 2009 02:09:19 -0700 (PDT)
Message-Id: <20090408.020919.22840656.davem@davemloft.net>
To: shen@cn.fujitsu.com
Cc: bhutchings@solarflare.com, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] IPv4/IPv6: update sysctl files
From: David Miller <davem@davemloft.net>
In-Reply-To: <49DC6569.5030908@cn.fujitsu.com>
References: <49DC19D5.7090101@cn.fujitsu.com>
	<20090408.001828.262566823.davem@davemloft.net>
	<49DC6569.5030908@cn.fujitsu.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shen Feng <shen@cn.fujitsu.com>
Date: Wed, 08 Apr 2009 16:50:49 +0800

> /proc/sys/net/ipv4/tcp_mem is a inet sysctl, but it also controls the tcp v6.
> So it's also a inet6 sysctl. Is it intentional?

Yes, please just drop this.
