Return-Path: <linux-kernel-owner+w=401wt.eu-S1756363AbYESIuP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756363AbYESIuP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 04:50:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751439AbYESIt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 04:49:59 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:57182 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751356AbYESIt6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 04:49:58 -0400
Date: Mon, 19 May 2008 12:49:48 +0200
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: 2.6.26-rc1 regression since 2.6.25
Message-ID: <20080519104948.GA4557@ics.muni.cz>
References: <20080512110450.GA6399@ics.muni.cz> <Pine.LNX.4.44L0.0805131554370.2563-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.44L0.0805131554370.2563-100000@iolanthe.rowland.org>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Muni-Spam-TestIP: 147.251.3.109
X-Muni-Envelope-From: xhejtman@anubis.ics.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Mon, 19 May 2008 10:49:50 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2008 at 04:06:20PM -0400, Alan Stern wrote:
> > I did. The dmesg is attached to the bug:
> > http://bugzilla.kernel.org/show_bug.cgi?id=10630
> 
> It looks as though the dock's USB hub may not be working right.

Maybe, Lenovo HW is a piece of crap. Anyway, it worked up to 2.6.25
(including).

> Just as a test, can you try applying gregkh-04-usb-2.6.26-rc2.patch 
> (it applies to 2.6.26-rc2, obviously) from
> 
> 	http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/
> 
> and attaching the dmesg log from that?  It contains extra debugging not 
> present in the vanilla kernel -- make sure that you keep 
> CONFIG_USB_DEBUG enabled.

I did another attachement of the dmesg to the bugzilla.

-- 
Luká¹ Hejtmánek
