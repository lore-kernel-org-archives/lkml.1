Return-Path: <linux-kernel-owner+w=401wt.eu-S1758897AbXHTKqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758897AbXHTKqQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 06:46:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754548AbXHTKqA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 06:46:00 -0400
Received: from ftp.linux-mips.org ([194.74.144.162]:49599 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779AbXHTKqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 06:46:00 -0400
Date: Mon, 20 Aug 2007 11:44:19 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: David Brownell <david-b@pacbell.net>
Cc: Atsushi Nemoto <anemo@mba.ocn.ne.jp>, a.zummo@towertech.it,
       linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com
Subject: Re: [PATCH] rtc: Make rtc-rs5c348 driver hotplug-aware (take 2)
Message-ID: <20070820104419.GD4493@linux-mips.org>
References: <20070819.223210.21590535.anemo@mba.ocn.ne.jp> <200708191849.16648.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708191849.16648.david-b@pacbell.net>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 19, 2007 at 06:49:16PM -0700, David Brownell wrote:

> On Sunday 19 August 2007, Atsushi Nemoto wrote:
> > The rtc-rs5c348 SPI driver name doesn't match its module name, which
> > prevents it from properly hotplugging.  There is only one in-tree user
> > of its driver, which is fixed by this patch too.
> > 
> > Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
> 
> ACK.

Okay, will merge this one.

  Ralf
