Return-Path: <linux-kernel-owner+w=401wt.eu-S1756158AbXLBT1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158AbXLBT1T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 14:27:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752621AbXLBT1K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 14:27:10 -0500
Received: from styx.suse.cz ([82.119.242.94]:55920 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750954AbXLBT1J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 14:27:09 -0500
Date: Sun, 2 Dec 2007 20:27:07 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Mark Lord <lkml@rtr.ca>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, rubini@vision.unipv.it,
       linux-input@vger.kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: 2.6.24:  false double-clicks from USB mouse
In-Reply-To: <47530680.6020206@rtr.ca>
Message-ID: <Pine.LNX.4.64.0712022025250.13260@jikos.suse.cz>
References: <4752DB8C.50608@rtr.ca> <4752E432.10504@rtr.ca>
 <Pine.LNX.4.64.0712021903460.12208@twin.jikos.cz> <4752F6C7.4040904@rtr.ca>
 <Pine.LNX.4.64.0712021918500.13260@jikos.suse.cz> <4752FE11.2050200@rtr.ca>
 <4752FEFE.3000600@rtr.ca> <Pine.LNX.4.64.0712022007360.13260@jikos.suse.cz>
 <47530680.6020206@rtr.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 Dec 2007, Mark Lord wrote:

> Right now it's double-clicking just about everything. If I unplug/replug 
> it, things behave for a while. Still want the HID_DEBUG output?  
> (rebooting shortly)

Yes, definitely. I currently don't have an idea what might be causing it, 
and I am unable to reproduce it here.

If HID DEBUG doesn't reveal anything interesting, we would probably need 
usbmon dump too.

-- 
Jiri Kosina
SUSE Labs
