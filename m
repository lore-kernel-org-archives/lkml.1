Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752382Ab0BWJ3g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 04:29:36 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54815
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750953Ab0BWJ3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 04:29:35 -0500
Date: Tue, 23 Feb 2010 01:29:52 -0800 (PST)
Message-Id: <20100223.012952.234072545.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: pull request: wireless-2.6 2010-02-22
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100222182653.GB2988@tuxdriver.com>
References: <20100222182653.GB2988@tuxdriver.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Mon, 22 Feb 2010 13:26:53 -0500

> I have a handful of late-breakers for iwlwifi.  The one from Dan
> Halperin moves a single line of code and is a fix for an 802.11n
> regression introduced in the 2.6.33 cycle.  The other two combine
> to address a problem that causes the wireless LAN connection to
> die without any error message.  It has been developed and tested in
> combination between the Intel wireless team and a contributor from
> Red Hat.  I hope you will consider including these for 2.6.33 if at
> all possible.
> 
> Please let me know if there are problems!

Pulled, thanks John.
