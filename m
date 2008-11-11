Return-Path: <linux-kernel-owner+w=401wt.eu-S1754746AbYKKFiN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746AbYKKFiN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 00:38:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751322AbYKKFhz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 00:37:55 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55444
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751198AbYKKFhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 00:37:54 -0500
Date: Mon, 10 Nov 2008 21:37:53 -0800 (PST)
Message-Id: <20081110.213753.223716878.davem@davemloft.net>
To: jianjun@zeuux.org
Cc: linville@tuxdriver.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH] nets: fix a buffer overrun
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081108023558.GB6384@ubuntu>
References: <20081108023558.GB6384@ubuntu>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jianjun Kong <jianjun@zeuux.org>
Date: Sat, 8 Nov 2008 10:35:58 +0800

> net/mac80211/debugfs_sta.c
> The trailing zero was written to state[4], it's out of bounds.
> 
> Signed-off-by: Jianjun Kong <jianjun@zeuux.org>

Applied, thank you.
