Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757443Ab0BQVx4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 16:53:56 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37732
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750869Ab0BQVxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 16:53:53 -0500
Date: Wed, 17 Feb 2010 13:54:08 -0800 (PST)
Message-Id: <20100217.135408.67924035.davem@davemloft.net>
To: joe@perches.com
Cc: david-b@pacbell.net, gregkh@suse.de, tilman@imap.cc,
       netdev@vger.kernel.org, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 net-next 0/2] usbnet: Use (netdev|netif)_<level>
 macros
From: David Miller <davem@davemloft.net>
In-Reply-To: <1266443067.8446.179.camel@Joe-Laptop.home>
References: <cover.1266438216.git.joe@perches.com>
	<20100217.133846.181531049.davem@davemloft.net>
	<1266443067.8446.179.camel@Joe-Laptop.home>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Wed, 17 Feb 2010 13:44:27 -0800

> On Wed, 2010-02-17 at 13:38 -0800, David Miller wrote:
>> 'allmodconfig' works well for build testing.  :-)
> 
> And takes ~6 hours on my netbook ;)

Takes ~6 minutes here :-)

Well, if you're making network device changes, having all of
the wired and wireless drivers enabled in your build is probably
a pretty good idea and should take only 1 hour on your laptop :)

A 6 fold increase!

> Do you know of an ssh-able test build system?

Besides the set of Niagara boxes I have here in my laundry room, no
sorry :-)
