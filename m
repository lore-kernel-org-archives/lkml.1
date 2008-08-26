Return-Path: <linux-kernel-owner+w=401wt.eu-S1760433AbYHZTGy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760433AbYHZTGy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 15:06:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758825AbYHZTGn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 15:06:43 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35661 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758884AbYHZTGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 15:06:42 -0400
Date: Tue, 26 Aug 2008 20:06:39 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Hugh Dickins <hugh@veritas.com>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH] ipv4: mode 0555 in ipv4_skeleton
Message-ID: <20080826190639.GZ28946@ZenIV.linux.org.uk>
References: <Pine.LNX.4.64.0808261950390.4716@blonde.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0808261950390.4716@blonde.site>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2008 at 08:00:03PM +0100, Hugh Dickins wrote:
> vpnc on today's kernel says Cannot open "/proc/sys/net/ipv4/route/flush":
> d--------- 0 root root 0 2008-08-26 11:32 /proc/sys/net/ipv4/route
> d--------- 0 root root 0 2008-08-26 19:16 /proc/sys/net/ipv4/neigh
> 
> Signed-off-by: Hugh Dickins <hugh@veritas.com>

Acked-by: Al Viro <viro@zeniv.linux.org.uk>
