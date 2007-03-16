Return-Path: <linux-kernel-owner+w=401wt.eu-S965689AbXCPRDI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965689AbXCPRDI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 13:03:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965693AbXCPRDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 13:03:08 -0400
Received: from smtp.osdl.org ([65.172.181.24]:52831 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965689AbXCPRDF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 13:03:05 -0400
Date: Fri, 16 Mar 2007 09:59:32 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Thomas Glanzmann <thomas@glanzmann.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andreas =?UTF-8?B?QWxsZ8O2d2Vy?= <andreas.allgoewer@web.de>,
       Michael Gernoth <simigern@cip.informatik.uni-erlangen.de>
Subject: Re: sky2 PHY setup
Message-ID: <20070316095932.5e920222@freekitty>
In-Reply-To: <20070316002912.GB17594@cip.informatik.uni-erlangen.de>
References: <20070202102705.3cf028a6@freekitty>
	<20070202210934.GM1693@cip.informatik.uni-erlangen.de>
	<20070202151601.677ec5d9@freekitty>
	<20070203073012.GO1693@cip.informatik.uni-erlangen.de>
	<20070205090429.31d7bd32@freekitty>
	<20070222193611.GR20035@cip.informatik.uni-erlangen.de>
	<20070316002912.GB17594@cip.informatik.uni-erlangen.de>
Organization: Linux Foundation
X-Mailer: Sylpheed-Claws 2.5.0-rc3 (GTK+ 2.10.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Mar 2007 01:29:12 +0100
Thomas Glanzmann <thomas@glanzmann.de> wrote:

> Hello Stephen,
> 
> > yesterday I pulled from Linus tree because I saw the sky2 updated and I
> > tried to break it but it seems that my problems are gone. I let you know
> > if anything pops up in the future.
> 
> bad news. I today tried the sky2 driver which is in Linus Kernel Tree
> (HEAD) on a machine with very high network load and it stopped working
> without any kernel messages after doing a flawless job under high load
> for 5 hours. My watchdog rebooted the machine after 500 seconds. ;-(
> 
>         Thomas

I have run for 2+ days under load without problems. It is hard to
reproduce or do much about your problem without more info.

-- 
Stephen Hemminger <shemminger@linux-foundation.org>
