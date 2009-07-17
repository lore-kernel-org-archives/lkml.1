Return-Path: <linux-kernel-owner+w=401wt.eu-S934786AbZGQRPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934786AbZGQRPq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 13:15:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934764AbZGQRPp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 13:15:45 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58518
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934751AbZGQRPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 13:15:45 -0400
Date: Fri, 17 Jul 2009 10:15:50 -0700 (PDT)
Message-Id: <20090717.101550.223298982.davem@davemloft.net>
To: zbr@ioremap.net
Cc: vapier@gentoo.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 1/3] connector: make callback argument type explicit
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090716101957.GA9586@ioremap.net>
References: <1247696049-15699-1-git-send-email-vapier@gentoo.org>
	<20090716101957.GA9586@ioremap.net>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Evgeniy Polyakov <zbr@ioremap.net>
Date: Thu, 16 Jul 2009 14:19:57 +0400

> Hi Mike.
> 
> Your patches look good, thanks a lot.
> David, please apply to the appropriate tree.

Applied to net-next-2.6, but I am being very generous.

In the future please make sure netdev@vger.kernel.org receives all
networking patch postings so that they properly get tracked at:

	http://patchwork.ozlabs.org/project/netdev/list/

Otherwise they risk getting lost.
