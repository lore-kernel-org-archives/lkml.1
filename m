Return-Path: <linux-kernel-owner+w=401wt.eu-S1754112AbZKIEzW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112AbZKIEzW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 23:55:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753872AbZKIEzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 23:55:21 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51249
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753752AbZKIEzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 23:55:20 -0500
Date: Sun, 08 Nov 2009 20:55:46 -0800 (PST)
Message-Id: <20091108.205546.141103466.davem@davemloft.net>
To: arnd@arndb.de
Cc: linux-kernel@vger.kernel.org, hch@lst.de, netdev@vger.kernel.org,
       dwmw2@infradead.org
Subject: Re: [RFC, PATCH 0/7] net, compat_ioctl: move handlers to
 net/socket.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <200911082231.48060.arnd@arndb.de>
References: <1257530949-9695-1-git-send-email-arnd@arndb.de>
	<20091106.204753.223665411.davem@davemloft.net>
	<200911082231.48060.arnd@arndb.de>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>
Date: Sun, 8 Nov 2009 22:31:47 +0100

> Any opinion on how to proceed with the ATM stuff? From my
> point of view, I'm fine with having moved it out of fs/compat_ioctl.c,
> but it's still a bit silly to have two half-complete implementations.

I haven't looked at that stuff yes, you can be sure it's in
my queue :-)
