Return-Path: <linux-kernel-owner+w=401wt.eu-S1754482AbYLGH5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482AbYLGH5i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 02:57:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752839AbYLGH5Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 02:57:25 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59406
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752853AbYLGH5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 02:57:24 -0500
Date: Sat, 06 Dec 2008 23:57:22 -0800 (PST)
Message-Id: <20081206.235722.37827733.davem@davemloft.net>
To: nick@nick-andrew.net
Cc: kou.ishizaki@toshiba.co.jp, jgarzik@pobox.com, jgarzik@redhat.com,
       jens@de.ibm.com, qhfeng.kernel@gmail.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix incorrect use of loose in spider_net.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081205030803.32099.345.stgit@marcab.local.tull.net>
References: <20081205030803.32099.345.stgit@marcab.local.tull.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nick Andrew <nick@nick-andrew.net>
Date: Fri, 05 Dec 2008 14:08:03 +1100

> Fix incorrect use of loose in spider_net.c
> 
> It should be 'lose', not 'loose'.
> 
> Signed-off-by: Nick Andrew <nick@nick-andrew.net>

Also applied, thanks Nick.
