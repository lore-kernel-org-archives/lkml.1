Return-Path: <linux-kernel-owner+w=401wt.eu-S1756614AbYCNHQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756614AbYCNHQr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 03:16:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751491AbYCNHQi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 03:16:38 -0400
Received: from eazy.amigager.de ([213.239.192.238]:43894 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970AbYCNHQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 03:16:38 -0400
Date: Fri, 14 Mar 2008 08:17:12 +0100
From: Tino Keitel <tino.keitel@gmx.de>
To: Alan Stern <stern@rowland.harvard.edu>, Jiri Kosina <jkosina@suse.cz>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: broken access to a USB HID device after suspend
Message-ID: <20080314071712.GA15654@dose.home.local>
Mail-Followup-To: Alan Stern <stern@rowland.harvard.edu>,
	Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
	linux-usb@vger.kernel.org
References: <20080313151403.GA5667@dose.home.local> <Pine.LNX.4.44L0.0803131450370.5744-100000@iolanthe.rowland.org> <20080314071336.GA14550@dose.home.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080314071336.GA14550@dose.home.local>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2008 at 08:13:36 +0100, Tino Keitel wrote:

[...]

> Well, I still don't have USB_DEBUG or usbmon enabled, but I just got
> that error again. I pulled the power plug from the LCD and replugged
> it, without success. Then I did a suspend/resume cycle, and it worked.

Forgot to mention: yesterday it was working, and the computer was
suspended overnight, without a reboot inbetween.

Regards,
Tino
