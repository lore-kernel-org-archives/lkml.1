Return-Path: <linux-kernel-owner+w=401wt.eu-S932463AbXCZV0Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932463AbXCZV0Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 17:26:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932444AbXCZV0Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 17:26:16 -0400
Received: from eazy.amigager.de ([213.239.192.238]:40799 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932194AbXCZV0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 17:26:15 -0400
Date: Mon, 26 Mar 2007 23:26:14 +0200
From: Tino Keitel <tino.keitel@gmx.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Oliver Neukum <oneukum@suse.de>, linux-usb-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [linux-usb-devel] possible USB regression with 2.6.21-rc4: iPod doesn't work
Message-ID: <20070326212614.GA15856@dose.home.local>
Mail-Followup-To: Alan Stern <stern@rowland.harvard.edu>,
	Oliver Neukum <oneukum@suse.de>,
	linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <20070326204744.GA24762@dose.home.local> <Pine.LNX.4.44L0.0703261712340.7079-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0703261712340.7079-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2007 at 17:15:53 -0400, Alan Stern wrote:

[...]

> The lack of messages from the iPod seems to indicate that the hub isn't
> working right.  You could try plugging the iPod into a different hub or
> directly into the computer.  Or maybe into a different port of that hub.

I already tried all of the above options, with the same result. Note
that all other USB devices (keyboard, mouse, hard disk with /home,
DVB-T box etc.) work fine.

I'm currently bisecting.

Regards,
Tino
