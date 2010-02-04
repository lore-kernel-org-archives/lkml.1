Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933115Ab0BDUEt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 15:04:49 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51682
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932906Ab0BDUEr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 15:04:47 -0500
Date: Thu, 04 Feb 2010 12:05:01 -0800 (PST)
Message-Id: <20100204.120501.110961896.davem@davemloft.net>
To: u.kleine-koenig@pengutronix.de
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, 12o3l@tiscali.nl,
       rmk+kernel@arm.linux.org.uk, netdev@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH 9/9] net: move am79c961's probe function to
 .devinit.text
From: David Miller <davem@davemloft.net>
In-Reply-To: <1265313417-5568-9-git-send-email-u.kleine-koenig@pengutronix.de>
References: <20100203150850.GA28815@kroah.com>
	<1265313417-5568-9-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Date: Thu,  4 Feb 2010 20:56:57 +0100

> @David Miller: this patch is in patchwork with State: Not Applicable.
> Does that mean that netdev isn't the right tree for this patch?

I was under the impression that someone would pick up the
whole set as a unit.

If you want me to take it into net-next-2.6 I can.
