Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935778Ab0BZJkB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 04:40:01 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40477
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935755Ab0BZJj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 04:39:58 -0500
Date: Fri, 26 Feb 2010 01:40:16 -0800 (PST)
Message-Id: <20100226.014016.200109230.davem@davemloft.net>
To: joe@perches.com
Cc: netdev@vger.kernel.org, gallatin@myri.com, brice@myri.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 2/7] drivers/net/myri10ge: Use pr_<level> and
 netdev_<level>
From: David Miller <davem@davemloft.net>
In-Reply-To: <0a98bb59c8ba36ea37bac53137e2b594bbc984d8.1266893507.git.joe@perches.com>
References: <cover.1266893507.git.joe@perches.com>
	<0a98bb59c8ba36ea37bac53137e2b594bbc984d8.1266893507.git.joe@perches.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Mon, 22 Feb 2010 18:56:58 -0800

> Add #define pr_fmt(fmt)
> Convert logging messages to pr_<level> and netdev_<level>
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied.
