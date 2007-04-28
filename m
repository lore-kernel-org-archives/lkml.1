Return-Path: <linux-kernel-owner+w=401wt.eu-S1752354AbXD1Un6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752354AbXD1Un6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 16:43:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754680AbXD1Un6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 16:43:58 -0400
Received: from mail1.vetienne.net ([87.98.219.23]:4976 "EHLO
	mail1.vetienne.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354AbXD1Un5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 16:43:57 -0400
From: Vincent ETIENNE <ve@vetienne.net>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] USB HID bug (was [PROBLEM] Bonding driver in linux-2.6.21-rc6-mm1)
Date: Sat, 28 Apr 2007 22:43:54 +0200
User-Agent: KMail/1.9.6
Cc: Jiri Kosina <jkosina@suse.cz>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-usb-devel@lists.sourceforge.net, Paul Walmsley <paul@booyaka.com>
References: <Pine.LNX.4.44L0.0704281547260.14565-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0704281547260.14565-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200704282243.54950.ve@vetienne.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Le Saturday 28 April 2007 21:50:30 Alan Stern, vous avez écrit :
> No, it isn't a problem in the USB core.  The device itself is messed up;
> it really does report idVendor and idProduct both equal to 0.
>
> Jiri, don't worry about all those other devices in the listing that also
> have idVendor and idProduct set to 0.  They aren't real devices at all;
> they are virtual root hubs.  You'll see what I mean if you look at their
> iManufacturer, iProduct, and iSerial strings.
>
> Alan Stern


So is it just a scary trace but without consequence that i could ignored ? 
May i ask you what is the device which is messed up ? ( Maybe should i change 
it ? )
