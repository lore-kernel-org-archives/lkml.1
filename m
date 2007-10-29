Return-Path: <linux-kernel-owner+w=401wt.eu-S1757873AbXJ2O32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757873AbXJ2O32 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 10:29:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754219AbXJ2O3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 10:29:20 -0400
Received: from twin.jikos.cz ([213.151.79.26]:44269 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752894AbXJ2O3T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 10:29:19 -0400
Date: Mon, 29 Oct 2007 15:28:31 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: Alan Stern <stern@rowland.harvard.edu>
cc: Dmitry Torokhov <dtor@insightbb.com>, linux-input@atrey.karlin.mff.cuni.cz,
       Adrian Bunk <bunk@kernel.org>, linux-usb-devel@lists.sourceforge.net,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Nick Sillik <n.sillik@temple.edu>, David Brownell <david-b@pacbell.net>,
       Torsten Kaiser <just.for.lkml@googlemail.com>
Subject: Re: [linux-usb-devel] [RFC: 2.6 patch] remove the USB_STORAGE_ONETOUCH
 driver
In-Reply-To: <Pine.LNX.4.44L0.0710291017520.4550-100000@iolanthe.rowland.org>
Message-ID: <Pine.LNX.4.64.0710291527130.18815@twin.jikos.cz>
References: <Pine.LNX.4.44L0.0710291017520.4550-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Oct 2007, Alan Stern wrote:

> You guys all sound confused about this. The original reason writing for 
> the onetouch driver was because the button on this disk drive isn't an 
> HID device!  That is, the drive doesn't include any of the usual HID 
> descriptors for the button and the button doesn't send HID-style 
> reports.

The only reason I was talking about it in terms of being a HID device was 
because Thorsten stated that usbhid driver gets bound to it.

Now that we know that Torsten was having different HW, my point is of 
course invalid :)

Thanks,

-- 
Jiri Kosina
