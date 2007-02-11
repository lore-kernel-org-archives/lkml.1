Return-Path: <linux-kernel-owner+w=401wt.eu-S932933AbXBKXzT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932933AbXBKXzT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 18:55:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932934AbXBKXzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 18:55:19 -0500
Received: from nigel.suspend2.net ([203.171.70.205]:48640 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932933AbXBKXzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 18:55:18 -0500
Subject: Re: NAK new drivers without proper power management?
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Willy Tarreau <w@1wt.eu>, Robert Hancock <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <200702120050.24539.rjw@sisk.pl>
References: <fa.xSKPgY66Q+DPCZ1pszFFfdrJ0To@ifi.uio.no>
	 <200702120041.22608.rjw@sisk.pl>
	 <1171237646.4493.148.camel@nigel.suspend2.net>
	 <200702120050.24539.rjw@sisk.pl>
Content-Type: text/plain
Date: Mon, 12 Feb 2007 10:55:17 +1100
Message-Id: <1171238117.4493.153.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Mon, 2007-02-12 at 00:50 +0100, Rafael J. Wysocki wrote:
> On Monday, 12 February 2007 00:47, Nigel Cunningham wrote:
> > Hi.
> > 
> > On Mon, 2007-02-12 at 00:41 +0100, Rafael J. Wysocki wrote:
> > > > I'm using M$ hibernation and Suspend2 to dual boot on our desktop (dtv
> > > > card that Linux doesn't support well yet), and I know other Suspend2
> > > > users doing the same. It's made earier by the fact that Suspend2 lets
> > > > you reboot instead of powering down.
> > > 
> > > Well, I don't know why you're saying it's a special capability of suspend2.
> > > Even the "old" swsusp has been able to do this since I can remember. ;-)
> > 
> > It does?! I just did cat /sys/power/disk and it only says platform. How
> > do you make swsusp reboot instead of powering down?
> 
> echo reboot > /sys/power/disk && echo disk > /sys/power/state

Ah. Perhaps you should make it show reboot when you cat it?

Regards,

Nigel

