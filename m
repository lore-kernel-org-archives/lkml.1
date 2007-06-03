Return-Path: <linux-kernel-owner+w=401wt.eu-S1759292AbXFCJt4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759292AbXFCJt4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 05:49:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754872AbXFCJts
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 05:49:48 -0400
Received: from twin.jikos.cz ([213.151.79.26]:38321 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753740AbXFCJts (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 05:49:48 -0400
Date: Sun, 3 Jun 2007 11:49:34 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: Kernel 2.6.22-rc3 breaks USB: Unable to get HID descriptor (error
 sending control message: Operation not permitted)
In-Reply-To: <Pine.LNX.4.64.0706021841520.3376@p34.internal.lan>
Message-ID: <Pine.LNX.4.64.0706031146470.29896@twin.jikos.cz>
References: <Pine.LNX.4.64.0706021841520.3376@p34.internal.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2 Jun 2007, Justin Piszcz wrote:

> p34:~# /lib/nut/newhidups -u nut -DDDDDD auto
> Checking device (050D/0912) (005/002)
> - VendorID: 050d
> - ProductID: 0912
> - Manufacturer: unknown
> - Product: unknown
> - Serial Number: unknown
> - Bus: 005
> Trying to match device
> Device matches
> failed to claim USB device, trying 2 more time(s)...
> detaching kernel driver from USB device...

Could you please provide strace outputs (or put it on the web somewhere if 
it's too big) for the failing and succeeding claiming of the device?

Thanks,

-- 
Jiri Kosina
