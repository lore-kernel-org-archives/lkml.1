Return-Path: <linux-kernel-owner+w=401wt.eu-S1750911AbXDNUZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750911AbXDNUZY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 16:25:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752253AbXDNUZX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 16:25:23 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:50638 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750911AbXDNUZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 16:25:21 -0400
Date: Sat, 14 Apr 2007 22:25:27 +0200
From: Adrian Bunk <bunk@stusta.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Tobias Diedrich <ranma@tdiedrich.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, pavel@suse.cz,
       linux-pm@lists.osdl.org, Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: Linux 2.6.21-rc6
Message-ID: <20070414202527.GH3691@stusta.de>
References: <Pine.LNX.4.64.0704051944230.6730@woody.linux-foundation.org> <200704142028.04694.rjw@sisk.pl> <20070414195611.GC806@yamamaya.is-a-geek.org> <200704142223.32410.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200704142223.32410.rjw@sisk.pl>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 14, 2007 at 10:23:31PM +0200, Rafael J. Wysocki wrote:
>...
> Also, would that be feasible for you to use 'shutdown' as a workaround in case
> the source of the problem is difficult to find and/or fix?

One person reporting a regression against a -rc kernel can mean
houndreds or thousands of people who will run into the same issue after 
2.6.21 got released if a manual workaround is required...

> Rafael

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

