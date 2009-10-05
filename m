Return-Path: <linux-kernel-owner+w=401wt.eu-S1758452AbZJEHMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758452AbZJEHMs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 03:12:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758425AbZJEHMr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 03:12:47 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54632
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758390AbZJEHMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 03:12:45 -0400
Date: Mon, 05 Oct 2009 00:12:40 -0700 (PDT)
Message-Id: <20091005.001240.111554671.davem@davemloft.net>
To: joe@perches.com
Cc: linux-kernel@vger.kernel.org, chessman@tux.org, netdev@vger.kernel.org
Subject: Re: [PATCH 21/21] drivers/net/tlan.h: Convert printk(KERN_DEBUG to
 pr_dbg(
From: David Miller <davem@davemloft.net>
In-Reply-To: <29c66ee0bae26a0c352b4605e3f1fcbe0612f3a5.1254701151.git.joe@perches.com>
References: <cover.1254701151.git.joe@perches.com>
	<cover.1254701151.git.joe@perches.com>
	<29c66ee0bae26a0c352b4605e3f1fcbe0612f3a5.1254701151.git.joe@perches.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Sun,  4 Oct 2009 17:53:48 -0700

> Removed "TLAN: " prefix from debug printks, it's added by pr_fmt
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied to net-next-2.6
