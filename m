Return-Path: <linux-kernel-owner+w=401wt.eu-S1755572AbYGHNxy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572AbYGHNxy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 09:53:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752276AbYGHNxm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 09:53:42 -0400
Received: from smarthost1.greenhost.nl ([85.17.153.87]:43913 "EHLO
	smarthost1.samage.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbYGHNxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 09:53:40 -0400
Message-ID: <14162.84.245.32.19.1215525216.squirrel@secure.samage.net>
In-Reply-To: <13988.84.245.32.19.1215522030.squirrel@secure.samage.net>
References: <Pine.LNX.4.44L0.0806241032490.2160-100000@iolanthe.rowland.org>
    <13988.84.245.32.19.1215522030.squirrel@secure.samage.net>
Date: Tue, 8 Jul 2008 15:53:36 +0200 (CEST)
Subject: Re: 2.6.27-rc7-git1: usb-storage breakage with non-functional disk
From: "Indan Zupancic" <indan@nul.nu>
To: "Indan Zupancic" <indan@nul.nu>
Cc: "Alan Stern" <stern@rowland.harvard.edu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Matthew Dharm" <mdharm-usb@one-eyed-alien.net>,
       "USB development list" <linux-usb@vger.kernel.org>,
       "LKML" <linux-kernel@vger.kernel.org>, "Greg KH" <greg@kroah.com>,
       "linux-scsi" <linux-scsi@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
User-Agent: SquirrelMail/1.4.8
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: -0.2
X-Scan-Signature: 68e84d89c742f8c9e42c8c72d6372b71
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, July 8, 2008 15:00, Indan Zupancic wrote:
> Any idea why my cardreader doesn't work in the first place though?

In case it's useful, an usbmon dump can be found at http://pastebin.org/49630
This is the log of plugging in the thing and unplugging it again after it failed.
Corresponding dmesg output with USB and usb-storage debugging enabled at
http://pastebin.org/49631. This is on 2.6.26-rc9 with Alan's patch applied.

Regards,

Indan


