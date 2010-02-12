Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757494Ab0BLUK5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 15:10:57 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58458
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752978Ab0BLUKz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 15:10:55 -0500
Date: Fri, 12 Feb 2010 12:11:10 -0800 (PST)
Message-Id: <20100212.121110.181928763.davem@davemloft.net>
To: u.kleine-koenig@pengutronix.de
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, 12o3l@tiscali.nl,
       rmk+kernel@arm.linux.org.uk, netdev@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH 9/9] net: move am79c961's probe function to
 .devinit.text
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100204200638.GA3035@pengutronix.de>
References: <1265313417-5568-9-git-send-email-u.kleine-koenig@pengutronix.de>
	<20100204.120501.110961896.davem@davemloft.net>
	<20100204200638.GA3035@pengutronix.de>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Date: Thu, 4 Feb 2010 21:06:38 +0100

> On Thu, Feb 04, 2010 at 12:05:01PM -0800, David Miller wrote:
>> From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
>> Date: Thu,  4 Feb 2010 20:56:57 +0100
>> 
>> > @David Miller: this patch is in patchwork with State: Not Applicable.
>> > Does that mean that netdev isn't the right tree for this patch?
>> 
>> I was under the impression that someone would pick up the
>> whole set as a unit.
> Ah, OK.  I hope Greg does exactly that now.

I've tossed this into my net-next-2.6 tree anyways to make sure it
doesn't get lost.

Thanks.
