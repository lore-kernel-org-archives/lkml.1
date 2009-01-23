Return-Path: <linux-kernel-owner+w=401wt.eu-S1759492AbZAWHtn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759492AbZAWHtn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 02:49:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751971AbZAWHtc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 02:49:32 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39551
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751864AbZAWHtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 02:49:31 -0500
Date: Thu, 22 Jan 2009 23:49:33 -0800 (PST)
Message-Id: <20090122.234933.130619322.davem@davemloft.net>
To: jj@chaosbits.net
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, stable@kernel.org,
       jmforbes@linuxtx.org, zwane@arm.linux.org.uk, tytso@mit.edu,
       rdunlap@xenotime.net, davej@redhat.com, chuckw@quantumlinux.com,
       reviews@ml.cw.f00f.org, mkrufky@linuxtv.org, cebbert@redhat.com,
       cavokz@gmail.com, w@1wt.eu, rbranco@la.checkpoint.com, jake@lwn.net,
       eteo@redhat.com, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       florian@openwrt.org
Subject: Re: [patch 24/46] r6040: bump release number to 0.19
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LNX.2.00.0901230225430.12187@swampdragon.chaosbits.net>
References: <20090123010651.683741823@mini.kroah.org>
	<20090123011219.GY19756@kroah.com>
	<alpine.LNX.2.00.0901230225430.12187@swampdragon.chaosbits.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesper Juhl <jj@chaosbits.net>
Date: Fri, 23 Jan 2009 02:31:22 +0100 (CET)

> On Thu, 22 Jan 2009, Greg KH wrote:
> 
> > 2.6.28-stable review patch.  If anyone has any objections, please let us know.
> > 
> 
> It's simple enough, sure, but it doesn't really conform to the guidelines 
> set out for -stable patches in Documentation/stable_kernel_rules.txt : 

We went over this two release ago.

Version bumps for drivers are fine.

Please bring this up again and again every time you see it in the
future too, thanks. :-/

