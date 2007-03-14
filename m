Return-Path: <linux-kernel-owner+w=401wt.eu-S965498AbXCPQdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965498AbXCPQdt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 12:33:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965484AbXCPQdt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 12:33:49 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3015 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933786AbXCPQdr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 12:33:47 -0400
Date: Wed, 14 Mar 2007 20:08:19 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, debian-user@lists.debian.org,
       bytes@linuxgazette.net
Subject: Re: Intel Core Duo/Solo Temperature Monitoring Working On Intel DG965 Motherboard
Message-ID: <20070314200818.GA4006@ucw.cz>
References: <Pine.LNX.4.64.0703100707320.3807@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703100707320.3807@p34.internal.lan>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> DISCLAIMER: This patch is still experimental. 
> AUTHOR: Rudolf Marek has written the coretemp module for 
> Intel Core Duo/Solo
> processors.

This is not proper changelog, see Doc*/Submit*.

> +Author: Rudolf Marek
> +Contact: Rudolf Marek <edited_out>

Heh.

> +The TjMax temperature is set to 85C if undocumented 
> model specific register
> +(UMSR) 0xee has bit 30 set. If not the TjMax is 100C as 
> documented in processor
> +datasheet. Intel will not disclose this information to 
> individuals.

ROFL.

Missing signed-off-by:...
						Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
