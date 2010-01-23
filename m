Return-Path: <linux-kernel-owner+w=401wt.eu-S1752528Ab0AWJJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752528Ab0AWJJc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 04:09:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752144Ab0AWJJa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 04:09:30 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51323
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751943Ab0AWJJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 04:09:29 -0500
Date: Sat, 23 Jan 2010 01:09:41 -0800 (PST)
Message-Id: <20100123.010941.186975038.davem@davemloft.net>
To: rjmx@rjmx.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Please add support for Microsoft MN-120 PCMCIA network
 card
From: David Miller <davem@davemloft.net>
In-Reply-To: <87r5pmt1kn.wl%rjmx@rjmx.net>
References: <87r5pmt1kn.wl%rjmx@rjmx.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ron Murray <rjmx@rjmx.net>
Date: Tue, 19 Jan 2010 13:02:48 -0500

> Please add support for Microsoft MN-120 PCMCIA network card. It's an
> old card, I know, but adding support is very easy. You just need to
> get tulip_core.c to recognise its vendor/device ID.
> 
> Patch for kernel 2.6.32.4 (and many previous) attached.
 ...
> Signed-off-by: Ron Murray <rjmx@rjmx.net>

Applied, thanks.
