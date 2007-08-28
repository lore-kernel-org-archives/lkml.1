Return-Path: <linux-kernel-owner+w=401wt.eu-S1754622AbXH1Wlk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622AbXH1Wlk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 18:41:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753575AbXH1Wl2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 18:41:28 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35321
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753324AbXH1Wl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 18:41:28 -0400
Date: Tue, 28 Aug 2007 15:41:26 -0700 (PDT)
Message-Id: <20070828.154126.108742911.davem@davemloft.net>
To: crquan@gmail.com
Cc: kuznet@ms2.inr.ac.ru, jmorris@namei.org, kaber@coreworks.de,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netlink: use container_of instead
From: David Miller <davem@davemloft.net>
In-Reply-To: <11883283241594-git-send-email-crquan@gmail.com>
References: <11883283241594-git-send-email-crquan@gmail.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Denis Cheng <crquan@gmail.com>
Date: Wed, 29 Aug 2007 03:12:04 +0800

> this could make future redesign of struct netlink_sock easier.
> 
> Signed-off-by: Denis Cheng <crquan@gmail.com>

Seems reasonable, patch applied, thanks.
