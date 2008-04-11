Return-Path: <linux-kernel-owner+w=401wt.eu-S1758119AbYDKDvl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758119AbYDKDvl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 23:51:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757033AbYDKDva
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 23:51:30 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38720
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756970AbYDKDv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 23:51:29 -0400
Date: Thu, 10 Apr 2008 20:51:30 -0700 (PDT)
Message-Id: <20080410.205130.193698307.davem@davemloft.net>
To: lkml@rtr.ca
Cc: yoshfuji@linux-ipv6.org, jesper.juhl@gmail.com, tilman@imap.cc,
       jeff@garzik.org, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, xemul@openvz.org, torvalds@osdl.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH 2.6.25] net sockets: fix timewait namespace regression
From: David Miller <davem@davemloft.net>
In-Reply-To: <47FED872.7010604@rtr.ca>
References: <47FEB0E3.8080507@rtr.ca>
	<20080411.115907.116626245.yoshfuji@linux-ipv6.org>
	<47FED872.7010604@rtr.ca>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Lord <lkml@rtr.ca>
Date: Thu, 10 Apr 2008 23:18:10 -0400

> Works perfectly, thanks.  Looks obvious, too.
> Push it out to Linus now for 2.6.25.
> 
> Acked-by: Mark Lord <mlord@pobox.com>

Will do, thanks for testing.
