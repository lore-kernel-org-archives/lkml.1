Return-Path: <linux-kernel-owner+w=401wt.eu-S1751367AbXBVR2O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751367AbXBVR2O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 12:28:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751382AbXBVR2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 12:28:14 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41215
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751367AbXBVR2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 12:28:13 -0500
Date: Thu, 22 Feb 2007 09:28:12 -0800 (PST)
Message-Id: <20070222.092812.112620509.davem@davemloft.net>
To: jsimmons@infradead.org
Cc: Joel.Becker@oracle.com, lists@onerussian.com, rpurdie@rpsys.net,
       akpm@linux-foundation.org, linux-fbdev-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [Linux-fbdev-devel] no backlight on radeon after recent kernel
 "upgrade"s
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0702221549530.29542@pentafluge.infradead.org>
References: <Pine.LNX.4.64.0702220109450.17121@pentafluge.infradead.org>
	<20070222020951.GR7920@ca-server1.us.oracle.com>
	<Pine.LNX.4.64.0702221549530.29542@pentafluge.infradead.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: James Simmons <jsimmons@infradead.org>
Date: Thu, 22 Feb 2007 15:55:24 +0000 (GMT)

> I just tested various confirations of backlight support. Backlight is 
> ALWAYS selected by default when you select a particular fbdev driver that 
> has backlight support. You just have the option to turn it off if you 
> want. These problems are showing up because of stale .config files.

BTW, enabling the backlight option broke things for me with
Radeon on sparc64 too, FWIW.

And when the option was presented to me for the first time,
the default was yes, so that's what I gave it.

This is what a lot of users would see.
