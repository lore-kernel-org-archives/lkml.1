Return-Path: <linux-kernel-owner+w=401wt.eu-S1761433AbYELLFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761433AbYELLFy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 07:05:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760779AbYELLFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 07:05:44 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:38705 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760723AbYELLFT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 07:05:19 -0400
Date: Mon, 12 May 2008 13:04:50 +0200
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: 2.6.26-rc1 regression since 2.6.25
Message-ID: <20080512110450.GA6399@ics.muni.cz>
References: <20080509151924.GA30644@kroah.com> <Pine.LNX.4.44L0.0805091447070.2648-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.44L0.0805091447070.2648-100000@iolanthe.rowland.org>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Muni-Spam-TestIP: 147.251.3.109
X-Muni-Envelope-From: xhejtman@anubis.ics.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Mon, 12 May 2008 13:04:53 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2008 at 02:47:45PM -0400, Alan Stern wrote:
> On Fri, 9 May 2008, Greg KH wrote:
> 
> > Can you just boot the box and then plug it into the dock and show the
> > log file for that?
> 
> If you can, use a kernel that has CONFIG_USB_DEBUG turned on.

I did. The dmesg is attached to the bug:
http://bugzilla.kernel.org/show_bug.cgi?id=10630

-- 
Luká¹ Hejtmánek
