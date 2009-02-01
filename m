Return-Path: <linux-kernel-owner+w=401wt.eu-S1753058AbZBAJF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753058AbZBAJF2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 04:05:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752105AbZBAJFA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 04:05:00 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35213
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751673AbZBAJE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 04:04:58 -0500
Date: Sun, 01 Feb 2009 01:04:55 -0800 (PST)
Message-Id: <20090201.010455.124561041.davem@davemloft.net>
To: jeremy@goop.org
Cc: jeff@garzik.org, shemminger@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Subject: Re: [PATCH] net: add ARP notify option for devices
From: David Miller <davem@davemloft.net>
In-Reply-To: <4981FA36.2000301@goop.org>
References: <4981FA36.2000301@goop.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy@goop.org>
Date: Thu, 29 Jan 2009 10:49:26 -0800

> This adds another inet device option to enable gratuitous ARP
> when device is brought up or address change. This is handy for
> clusters or virtualization.
> 
> Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

I'm fine with this, applied, thanks.
