Return-Path: <linux-kernel-owner+w=401wt.eu-S1755591AbYHGM70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755591AbYHGM70 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 08:59:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752527AbYHGM6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 08:58:37 -0400
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:49274 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751796AbYHGM6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 08:58:36 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvgEAK5qmkjZiDIu/2dsb2JhbACBWKsS
Date: Thu, 7 Aug 2008 12:24:26 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Florian Fainelli <florian.fainelli@telecomint.eu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [WATCHDOG] v2.6.27-rc patches
Message-ID: <20080807102426.GD29386@infomag.infomag.iguana.be>
References: <20080806202918.GA29386@infomag.infomag.iguana.be> <200808071038.49779.florian.fainelli@telecomint.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808071038.49779.florian.fainelli@telecomint.eu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Florian,

> > Please pull from 'master' branch of
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git
> > or if master.kernel.org hasn't synced up yet:
> > 	master.kernel.org:/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git
> 
> I am not seeing the rc32434_wdt nor the rdc321x_wdt drivers, is that normal ? 
> Do you want me to update those ?

I'm putting those in the watchdog tree tonight.
I'll contact you when it's done to see if I have everything that has been
discussed in the past. I'll also check for coding style on these new drivers.

Kind regards,
Wim.

