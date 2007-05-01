Return-Path: <linux-kernel-owner+w=401wt.eu-S1753688AbXEABKz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753688AbXEABKz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 21:10:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753678AbXEABKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 21:10:55 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36602
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753010AbXEABKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 21:10:53 -0400
Date: Mon, 30 Apr 2007 18:10:54 -0700 (PDT)
Message-Id: <20070430.181054.115915108.davem@davemloft.net>
To: clem@clem.clem-digital.net
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-git3 Broke UDP Reception
From: David Miller <davem@davemloft.net>
In-Reply-To: <200705010044.l410ifIv003245@clem.clem-digital.net>
References: <200705010044.l410ifIv003245@clem.clem-digital.net>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pete Clements <clem@clem.clem-digital.net>
Date: Mon, 30 Apr 2007 20:44:41 -0400 (EDT)

> fyi:
> Looks like 2.6.21-git3 broke UDP inbound. Inbound UDP traffic
> generates an ICMP port unreachable, dns/ntp. Git2 works fine.

Already fixed in Linus's tree.
