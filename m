Return-Path: <linux-kernel-owner+w=401wt.eu-S1756713AbZHQD5y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756713AbZHQD5y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 23:57:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752973AbZHQD5x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 23:57:53 -0400
Received: from mail.gmx.net ([213.165.64.20]:35847 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752541AbZHQD5w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 23:57:52 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+dEsNLH+6d9mqYb1jizWsQaB5eRurpxfaGDYN7OQ
	e47uduCs708KwQ
Subject: Re: [PATCH 00/22] Staging: rt{286,287,307}0: various fixes/cleanups
From: Mike Galbraith <efault@gmx.de>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
In-Reply-To: <1250480865.7243.15.camel@marge.simson.net>
References: <20090816192934.3789.3648.sendpatchset@localhost.localdomain>
	 <1250480865.7243.15.camel@marge.simson.net>
Content-Type: text/plain
Date: Mon, 17 Aug 2009 05:57:51 +0200
Message-Id: <1250481471.7243.19.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.48
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devel@driverdev.osuosl.org seems to make replies arrive only
at /dev/null, so I'll try again without.

Hi. This is the qmail-send program at mail.gmx.net.
I'm afraid I wasn't able to deliver your message to the following addresses.
This is a permanent error; I've given up. Sorry it didn't work out.

<devel@driverdev.osuosl.org>:
140.211.166.17_does_not_like_recipient./Remote_host_said:_550_5.1.1_<devel@driverdev.osuosl.org>:_Recipient_address_rejected:_User_unknown_in_virtual_alias_table/Giving_up_on_140.211.166.17./


On Mon, 2009-08-17 at 05:47 +0200, Mike Galbraith wrote:
> On Sun, 2009-08-16 at 21:29 +0200, Bartlomiej Zolnierkiewicz wrote:
> > Hi,
> > 
> > Some fixes, some cleanups and a lot of preparations for finally merging
> > rt{28,30}70 drivers together.
> > 
> > Tested with RT2860 (Asus Eee 901) and RT3070 (el cheapo USB dongle that
> > I've bought recently to speed up the development, I'm posting this mail
> > using it right now) chipsets.
> 
> I plugged these into tip this morning (3, 5 and 21 needed hammering) and
> tried my box's onboard USB gizmo:
> 
> Bus 007 Device 003: ID 13d3:3247 IMC Networks 802.11 n/g/b Wireless LAN Adapter
> 
> Works fine here.
> 
> > PS I tried using rt2800usb driver found in 2.6.31-rc6 (with overdue fix
> > for memory corruption in rf cache from Pavel Roskin) for RT3070 chipset
> > but it doesn't seem to work yet (iwlist wlan0 scan => no stations)..
> 
> Yeah, I can ping/traceroute with it, but that's about it, seems to choke
> as soon as you need to xfer non-dinky packets.  (I would have thought
> that the corruption fix would swim upstream given it's utterly deadly)
> 
> 	-Mike

