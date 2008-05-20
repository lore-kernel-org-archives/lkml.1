Return-Path: <linux-kernel-owner+w=401wt.eu-S932643AbYETOL4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932643AbYETOL4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 10:11:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756592AbYETOLr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 10:11:47 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:51897 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755931AbYETOLq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 10:11:46 -0400
Date: Tue, 20 May 2008 16:11:32 +0200
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: Oliver Neukum <oliver@neukum.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       stern@rowland.harvard.edu, greg@kroah.com, linux-usb@vger.kernel.org
Subject: Re: [Bug #10630] USB devices plugged into dock are not discoverred
	until reload of ehci-hcd
Message-ID: <20080520141132.GG4764@ics.muni.cz>
References: <20080520123423.GA4764@ics.muni.cz> <200805201440.47217.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200805201440.47217.oliver@neukum.org>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Muni-Spam-TestIP: 147.251.3.109
X-Muni-Envelope-From: xhejtman@anubis.ics.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Tue, 20 May 2008 16:11:34 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2008 at 02:40:46PM +0200, Oliver Neukum wrote:
> > > > http://bugzilla.kernel.org/show_bug.cgi?id=10630
> > Hm, without USB_SUSPEND it works. So what next, considered fixed or any
> > further investigation is needed?
> 
> It is by no means fixed!
> 
> Now we find out what exactly doesn't work. Please apply this patch
> and provide "dmesg -c" before you plug in the device and after that.

Should I use USB_SUSPEND or not?
 
-- 
Luká¹ Hejtmánek
