Return-Path: <linux-kernel-owner+w=401wt.eu-S1751240AbXCORxP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751240AbXCORxP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 13:53:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751216AbXCORxP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 13:53:15 -0400
Received: from twin.jikos.cz ([213.151.79.26]:34919 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750773AbXCORxO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 13:53:14 -0400
Date: Thu, 15 Mar 2007 18:53:01 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
cc: Linux kernel <linux-kernel@vger.kernel.org>,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: USB Keyboard
In-Reply-To: <Pine.LNX.4.61.0703151345010.4487@chaos.analogic.com>
Message-ID: <Pine.LNX.4.64.0703151851190.12394@twin.jikos.cz>
References: <Pine.LNX.4.61.0703151331060.4442@chaos.analogic.com>
 <Pine.LNX.4.64.0703151835150.12394@twin.jikos.cz>
 <Pine.LNX.4.61.0703151345010.4487@chaos.analogic.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(added linux-usb-devel@lists.sourceforge.net to CC)

On Thu, 15 Mar 2007, linux-os (Dick Johnson) wrote:

> >> I have multiple AMD 64-bit servers in several configurations, with
> >> several different motherboards, which fail to recognize a USB keyboard
> >> when booted from a "stock" Linux kernel. They only work with a RedHat
> >> kernel! I have removed all but one CPU from one in an attempt to find
> >> the problem.
> > [...]
> >> linux-2.6.8 linux-2.6.9 linux-2.6.10 linux-2.6.11
> >> linux-2.6.11.9 linux-2.6.12 linux-2.6.12.5 linux-2.6.13
> >> linux-2.6.13.4 linux-2.6.15.4 linux-2.6.16.24 linux-2.6.16.4
> >> linux-2.6.19
> > Could you please turn on USB debugging (and also maybe HID debugging, but
> > usb debug should be more interesting now) and send us the logs?
> Ouch!  I can't do anything by copy from a screen! There is no way to get 
> `dmesg` without the keyboard! That's why I sent a request to 
> linux-kernel, hoping that the problem would sound familiar. All I can do 
> is boot the system (off a CD-ROM) and then pull the plug when the 
> keyboad doesn't work!

You state that this happens on different hardware configurations, which 
looks pretty strange, there are many 64bit amd systems with working USB 
keyboards.

Do you happen to have USB Legacy setting in BIOS? If so, could you try 
turning it off?

Also, does this happen only with one particular type of keyboard, or with 
various ones?

-- 
Jiri Kosina
