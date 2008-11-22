Return-Path: <linux-kernel-owner+w=401wt.eu-S1756924AbYKVH5Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756924AbYKVH5Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 02:57:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751205AbYKVH46
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 02:56:58 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45789
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751013AbYKVH45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 02:56:57 -0500
Date: Fri, 21 Nov 2008 23:56:56 -0800 (PST)
Message-Id: <20081121.235656.193713995.davem@davemloft.net>
To: jeffrey.t.kirsher@intel.com
Cc: qhfeng.kernel@gmail.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] driver/net/*: remove redundant argument comments
From: David Miller <davem@davemloft.net>
In-Reply-To: <9929d2390811212355j635e0e8iee0e53678efc5f09@mail.gmail.com>
References: <4927b790.0e0d6e0a.65cc.ffffcb05@mx.google.com>
	<9929d2390811212355j635e0e8iee0e53678efc5f09@mail.gmail.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Jeff Kirsher" <jeffrey.t.kirsher@intel.com>
Date: Fri, 21 Nov 2008 23:55:27 -0800

> I would agree that "@rx_ring: pointer to receive ring structure" is
> probably not the best documentation, but rather than removing it, I
> would suggest improving it.

Jeff, he's removing it because the function no longer takes
that argument any more.
