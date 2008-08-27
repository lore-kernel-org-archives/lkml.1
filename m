Return-Path: <linux-kernel-owner+w=401wt.eu-S1754925AbYH0Jfm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925AbYH0Jfm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 05:35:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753866AbYH0Jfc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 05:35:32 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42549
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753566AbYH0Jfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 05:35:31 -0400
Date: Wed, 27 Aug 2008 02:35:26 -0700 (PDT)
Message-Id: <20080827.023526.246070710.davem@davemloft.net>
To: viro@ZenIV.linux.org.uk
Cc: hugh@veritas.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] ipv4: mode 0555 in ipv4_skeleton
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080826190639.GZ28946@ZenIV.linux.org.uk>
References: <Pine.LNX.4.64.0808261950390.4716@blonde.site>
	<20080826190639.GZ28946@ZenIV.linux.org.uk>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@ZenIV.linux.org.uk>
Date: Tue, 26 Aug 2008 20:06:39 +0100

> On Tue, Aug 26, 2008 at 08:00:03PM +0100, Hugh Dickins wrote:
> > vpnc on today's kernel says Cannot open "/proc/sys/net/ipv4/route/flush":
> > d--------- 0 root root 0 2008-08-26 11:32 /proc/sys/net/ipv4/route
> > d--------- 0 root root 0 2008-08-26 19:16 /proc/sys/net/ipv4/neigh
> > 
> > Signed-off-by: Hugh Dickins <hugh@veritas.com>
> 
> Acked-by: Al Viro <viro@zeniv.linux.org.uk>

Applied, thanks everyone.
