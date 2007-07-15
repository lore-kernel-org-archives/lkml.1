Return-Path: <linux-kernel-owner+w=401wt.eu-S933312AbXGOCBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933312AbXGOCBW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 22:01:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763012AbXGOCBM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 22:01:12 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49816
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757550AbXGOCBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 22:01:11 -0400
Date: Sat, 14 Jul 2007 19:01:13 -0700 (PDT)
Message-Id: <20070714.190113.58787016.davem@davemloft.net>
To: bunk@stusta.de
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] make
 net/ipv4/inet_timewait_sock.c:__inet_twsk_kill() static
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070712235556.GU3492@stusta.de>
References: <20070712235556.GU3492@stusta.de>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@stusta.de>
Date: Fri, 13 Jul 2007 01:55:56 +0200

> This patch makes the needlessly global __inet_twsk_kill() static.
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>

Applied, thanks Adrian.
