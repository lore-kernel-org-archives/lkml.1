Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755606Ab0BJTgp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 14:36:45 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54240
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751736Ab0BJTgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 14:36:44 -0500
Date: Wed, 10 Feb 2010 11:36:58 -0800 (PST)
Message-Id: <20100210.113658.137273026.davem@davemloft.net>
To: johannes@sipsolutions.net
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2010-02-10
From: David Miller <davem@davemloft.net>
In-Reply-To: <1265829337.19075.0.camel@jlt3.sipsolutions.net>
References: <20100210185816.GB3286@tuxdriver.com>
	<20100210.110756.201335073.davem@davemloft.net>
	<1265829337.19075.0.camel@jlt3.sipsolutions.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>
Date: Wed, 10 Feb 2010 20:15:37 +0100

> It was intentional -- that sdev doesn't even have an irq member, but
> nobody ever noticed because of the wrong ifdef.

Ok, then this needs to be explained in the commit message.

