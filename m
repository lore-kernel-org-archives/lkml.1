Return-Path: <linux-kernel-owner+w=401wt.eu-S1758322AbZFKGod@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758322AbZFKGod (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 02:44:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755257AbZFKGoX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 02:44:23 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33260
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752996AbZFKGoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 02:44:22 -0400
Date: Wed, 10 Jun 2009 23:44:24 -0700 (PDT)
Message-Id: <20090610.234424.69074010.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-next-2.6 2009-06-10
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090610185639.GC3892@tuxdriver.com>
References: <20090610185639.GC3892@tuxdriver.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 10 Jun 2009 14:56:39 -0400

> Despite my previous optimistic prediction, I need to ask for one more
> 2.6.31 pull before/during the merge window... :-)
> 
> This one actually does have a number of bug fixes embedded within, as
> well as some further fleshing-out and usage of the new rfkill
> infrastructure changes that are already queued for 2.6.31.  The other
> bits are more minor, but they have already spent at least a few days in
> -next and I believe they are safe for 2.6.31.

Pulled, I'll push out after some build verifications.

> P.S.  For some reason (probably the 2.6.30 release) the public push on
> kernel.org seems to be taking a lot longer than usual.  So you probably
> want to ensure that the wireless-next-2.6 head matches 2f0accc13520 or
> just pull using ssh (or direct file access).

I verified this, but you can sidestep this entire problem by simply
giving me master.kernel.org SSH based URLs to pull from. :-)

