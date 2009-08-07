Return-Path: <linux-kernel-owner+w=401wt.eu-S1751978AbZHHPYZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751978AbZHHPYZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 11:24:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751886AbZHHPYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 11:24:25 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42721 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810AbZHHPYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 11:24:24 -0400
Date: Fri, 7 Aug 2009 20:07:55 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Gene Heskett <gene.heskett@verizon.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Strange wireless card?
Message-ID: <20090807180755.GB1728@ucw.cz>
References: <200908042306.36043.gene.heskett@verizon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200908042306.36043.gene.heskett@verizon.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2009-08-04 23:06:35, Gene Heskett wrote:
> Greetings;
> 
> Can anyone tell me if this pci wireless card is supported, or what its 
> status is?
> 
> >From lspci -v:
> 01:06.0 Ethernet controller: Marvell Technology Group Ltd. 88w8335 [Libertas] 802.11b/g Wireless (rev 03)
>         Subsystem: Netgear WG311v3 802.11g Wireless PCI Adapter
> 
> I have built a 2.6.31-rc5 kernel with the Marvel stuffs all enabled, but
> even a modprobe mwl8k, while apparently loading the driver, doesn't create
> any wireless devices in /dev.

I don't know much about Marvell, but I'd not expect anything in /dev...
dmesg?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
