Return-Path: <linux-kernel-owner+w=401wt.eu-S1754953AbXJJInS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754953AbXJJInS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 04:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752986AbXJJInK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 04:43:10 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52386
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752842AbXJJInJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 04:43:09 -0400
Date: Wed, 10 Oct 2007 01:43:11 -0700 (PDT)
Message-Id: <20071010.014311.115911329.davem@davemloft.net>
To: sfa.linux@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: skb_clone SMP race?
From: David Miller <davem@davemloft.net>
In-Reply-To: <dfad5c650710100137i74f444d8t221f1f195cc90e1@mail.gmail.com>
References: <dfad5c650710100137i74f444d8t221f1f195cc90e1@mail.gmail.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Santiago Font Arquer" <sfa.linux@gmail.com>
Date: Wed, 10 Oct 2007 10:37:57 +0200

>     I'm studying the implementation of sk_buff and I think there's a
> possible race condition in skb_clone (2.6.22.9)
>     The code is:

Please discuss networking code on netdev@vger.kernel.org which is
where the kernel networking developers are subscribed, thanks!
