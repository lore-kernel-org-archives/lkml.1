Return-Path: <linux-kernel-owner+w=401wt.eu-S1754585AbXHBEvG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585AbXHBEvG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 00:51:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751628AbXHBEu7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 00:50:59 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57842
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751290AbXHBEu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 00:50:58 -0400
Date: Wed, 01 Aug 2007 21:50:58 -0700 (PDT)
Message-Id: <20070801.215058.105431907.davem@davemloft.net>
To: michal.k.k.piotrowski@gmail.com
Cc: akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] Removal of duplicated include
 net/wanrouter/wanmain.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <46B0C9DD.8040701@googlemail.com>
References: <46B0C9DD.8040701@googlemail.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Date: Wed, 01 Aug 2007 19:58:53 +0200

> Hi,
> 
> There is no need to include linux/init.h twice
...
> Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>

Patch applied, thanks.
