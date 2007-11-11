Return-Path: <linux-kernel-owner+w=401wt.eu-S1757153AbXKKTC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757153AbXKKTC3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 14:02:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753603AbXKKTCT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 14:02:19 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:34898 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752543AbXKKTCS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 14:02:18 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas =?iso-8859-15?q?B=E4chler?= <thomas@archlinux.org>
Subject: Re: 2.6.24-rc1-g74521c28: oops during boot [<ffffffff881c03e4>] :power_supply:power_supply_show_property+0x94/0x150
Date: Sun, 11 Nov 2007 20:19:21 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
References: <472C5C2D.9010700@archlinux.org> <4736EE1C.3010500@archlinux.org> <473750B2.4060208@archlinux.org>
In-Reply-To: <473750B2.4060208@archlinux.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200711112019.21853.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 11 of November 2007, Thomas Bächler wrote:
> >>> http://bugzilla.kernel.org/show_bug.cgi?id=9299
> > 
> > I just tested again (with 2.6.24-rc2-gecd744ee). If I only load the 'ac'
> > kernel module and not the 'battery' kernel module, then the system boots
> > fine. However, if I load the 'battery' module during boot or later, I
> > still get the oops.
> > 
> > I am running 2.6.24-rc2-gecd744ee right now, but without the battery
> > module. I am forwarding this to the ACPI list as well.
> > 
> 
> Replying to myself again. Apparently, a fix for this bug was applied to
> the linux-acpi tree independently of my bug report, see here:
> http://git.kernel.org/?p=linux/kernel/git/lenb/linux-acpi-2.6.git;a=commit;h=4c41d3ad6544f1c9aec37c441af04f5d0ad3a731

I'm having some problems with accessing git.kernel.org right now.  I'll have a
look when it works again.

Thanks,
Rafael
