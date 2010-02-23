Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753758Ab0BWEcP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 23:32:15 -0500
Received: from mail.perches.com ([173.55.12.10]:1181 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752221Ab0BWEcO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 23:32:14 -0500
Subject: Re: [PATCH 3/4] gigaset: reduce syslog clutter
From: Joe Perches <joe@perches.com>
To: Tilman Schmidt <tilman@imap.cc>
Cc: Karsten Keil <isdn@linux-pingi.de>, David Miller <davem@davemloft.net>,
       Hansjoerg Lipp <hjlipp@web.de>, Karsten Keil <keil@b1-systems.de>,
       isdn4linux@listserv.isdn4linux.de, i4ldeveloper@listserv.isdn4linux.de,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 22 Feb 2010 20:32:11 -0800
Message-ID: <1266899531.9265.4.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Perhaps it'd be useful to add a ethtool/netif_msg interface
and classify the messages as appropriate.


