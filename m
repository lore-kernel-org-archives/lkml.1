Return-Path: <linux-kernel-owner+w=401wt.eu-S1756793AbYEIJUb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793AbYEIJUb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 05:20:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752746AbYEIJUW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 05:20:22 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:33669 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752099AbYEIJUV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 05:20:21 -0400
Date: Fri, 9 May 2008 11:20:06 +0200
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: 2.6.26-rc1 regression since 2.6.25
Message-ID: <20080509092006.GI31771@ics.muni.cz>
References: <20080505080227.GA5499@ics.muni.cz> <20080508202921.GA32617@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080508202921.GA32617@kroah.com>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Muni-Spam-TestIP: 147.251.3.109
X-Muni-Envelope-From: xhejtman@anubis.ics.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Fri, 09 May 2008 11:20:06 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2008 at 01:29:21PM -0700, Greg KH wrote:
> On Mon, May 05, 2008 at 10:02:27AM +0200, Lukas Hejtmanek wrote:
> > Hello,
> > 
> > as of some high versions of 2.6.25-gitXX and 2.6.26-rc1, USB devices pluged
> > into a dock (minidock for Lenovo ThinkPad T61) are not discoverred until
> > I reload ehci-hcd module with already plugged device.
> 
> Can you please post the kernel log file from when this happens?

I created an attachment to this bug.
http://bugzilla.kernel.org/show_bug.cgi?id=10630
 
-- 
Luká¹ Hejtmánek
