Return-Path: <linux-kernel-owner+w=401wt.eu-S1754919AbYKLWjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919AbYKLWjU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 17:39:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751986AbYKLWjD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 17:39:03 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35874
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751630AbYKLWjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 17:39:01 -0500
Date: Wed, 12 Nov 2008 14:39:01 -0800 (PST)
Message-Id: <20081112.143901.224895622.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2008-11-12
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081112222739.GK2411@tuxdriver.com>
References: <20081112222739.GK2411@tuxdriver.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 12 Nov 2008 17:27:39 -0500

> A few fixes intended for 2.6.28.  Included are a couple of USB IDs, a
> mac80211 fix to avoid sleeping during RCU, and a nasty hack to hostap to
> make it's skb->cb trickery work again...
> 
> Please let me know if there are problems!

Pulled, thanks John.
