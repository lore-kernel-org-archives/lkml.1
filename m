Return-Path: <linux-kernel-owner+w=401wt.eu-S1754345AbXKZTFL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754345AbXKZTFL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 14:05:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752408AbXKZTE7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 14:04:59 -0500
Received: from rv-out-0910.google.com ([209.85.198.190]:23387 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853AbXKZTE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 14:04:59 -0500
Message-ID: <1618816c0711261104m3177a2bas24446035557f9593@mail.gmail.com>
Date: Mon, 26 Nov 2007 12:04:47 -0700
From: "Raymano Garibaldi" <raymano@faunos.com>
To: "Alan Stern" <stern@rowland.harvard.edu>
Subject: [linux-usb-devel] [FEATURE REQUEST] Transparent hot plugging of root file system on portable storage devices.
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Denys Vlasenko" <vda.linux@googlemail.com>,
       "Kernel development list" <linux-kernel@vger.kernel.org>,
       "USB development list" <linux-usb-devel@lists.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I would like to request a feature in the Linux kernel that would allow
a user to unplug a live read-only root file system which exists on a
detachable storage device such as a USB key drive. The desired
behavior is that once the same device is reattached to the computer
the user can continue work transparently without having to reboot.

Having such a feature is becoming more important with advances in
detachable solid state drive technology.

Having the root FS on a wireless storage device such as D.A.V.E.
(http://www.seagate.com/www/en-us/products/consumer_electronics/DAVE)
would require such a feature in the kernel in case the wireless
connection between the storage device and the computer is temporarily
lost. The user should have the ability to continue work transparently
once the wireless connection is reestablished.

Thank you,
Raymano G.
