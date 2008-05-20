Return-Path: <linux-kernel-owner+w=401wt.eu-S1765048AbYETMem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765048AbYETMem (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 08:34:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752790AbYETMed
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 08:34:33 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:43710 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751372AbYETMec (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 08:34:32 -0400
Date: Tue, 20 May 2008 14:34:23 +0200
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: Oliver Neukum <oliver@neukum.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       stern@rowland.harvard.edu, greg@kroah.com, linux-usb@vger.kernel.org
Message-ID: <20080520123423.GA4764@ics.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Muni-Spam-TestIP: 147.251.3.109
X-Muni-Envelope-From: xhejtman@anubis.ics.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Tue, 20 May 2008 14:34:24 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<stern@rowland.harvard.edu>, Greg KH <greg@kroah.com>
Bcc: 
Subject: Re: [Bug #10630] USB devices plugged into dock are not discoverred
	until reload of ehci-hcd
Reply-To: 
In-Reply-To: <200805201327.34678.oliver@neukum.org>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb

On Tue, May 20, 2008 at 01:27:34PM +0200, Oliver Neukum wrote:
> > done.
> > http://bugzilla.kernel.org/show_bug.cgi?id=10630
> 
> Aha. Thanks.
> Please recompile without CONFIG_USB_SUSPEND

Hm, without USB_SUSPEND it works. So what next, considered fixed or any
further investigation is needed?

-- 
Luká¹ Hejtmánek
