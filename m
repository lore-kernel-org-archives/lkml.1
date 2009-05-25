Return-Path: <linux-kernel-owner+w=401wt.eu-S1755534AbZEYHxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534AbZEYHxT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 03:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752463AbZEYHxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 03:53:13 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60487
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752383AbZEYHxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 03:53:12 -0400
Date: Mon, 25 May 2009 00:53:11 -0700 (PDT)
Message-Id: <20090525.005311.249649223.davem@davemloft.net>
To: keil@b1-systems.de
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       i4ldeveloper@listserv.isdn4linux.de
Subject: Re: [mISDN PATCH v2 00/19] mISDN patchset for next
From: David Miller <davem@davemloft.net>
In-Reply-To: <cover.1243024967.git.kkeil@pingi.linux-pingi.de>
References: <cover.1243024967.git.kkeil@pingi.linux-pingi.de>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Karsten Keil <keil@b1-systems.de>
Date: Fri, 22 May 2009 22:42:47 +0200

> This is a update of the mISDN driver for net-next.
> It syncs the mISDN driver with the development on git.misdn.org.
> More updates (new hardware support) will follow.
> 
> You can pull it from 
> git://master.kernel.org/pub/scm/linux/kernel/git/kkeil/ISDN-2.6-net-next.git for_dave
> 
> Andreas Eversberg (12):
>   Add watchdog functionality to hfcmulti driver
>   DSP now uses ring buffer for echo canceler

There is no way I'm pulling from that tree, even with the fixed
up patch #9.

How in the world is anyone supposed to know these are mISDN changes
by looking at those changlog header lines?  They say nothing about
the subsystem they are in.

I've modified every commit log message so that it says:

mISDN: foo bar baz

instead of the anonymous stuff above.
