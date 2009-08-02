Return-Path: <linux-kernel-owner+w=401wt.eu-S1753162AbZHBQz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162AbZHBQz1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 12:55:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753109AbZHBQz1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 12:55:27 -0400
Received: from xenotime.net ([72.52.64.118]:39877 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751837AbZHBQz0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 12:55:26 -0400
Date: Sun, 2 Aug 2009 09:55:23 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Dave Young <hidave.darkstar@gmail.com>, webmaster@kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: mm/-next release on kernel.org web page?
Message-Id: <20090802095523.e08166e3.rdunlap@xenotime.net>
In-Reply-To: <a8e1da0908020056mbf28eaw611c605693eb3eff@mail.gmail.com>
References: <a8e1da0908020056mbf28eaw611c605693eb3eff@mail.gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 Aug 2009 15:56:20 +0800 Dave Young wrote:

> Hi,
> 
> The last mm patchset is 2.6.28-rc2-mm1. We can not download -mm
> patchset from kernel.org web page since the -next tree born.
> 
> Could you consider put mmtom release there just like before? And even
> -next tree patchset? It will be more convenient for users who test
> kernel just by downloading from web. Now it's impossible for them to
> test these patchsets because they normally do not subscribe to lkml.


from www.kernel.org:
For comments about the web pages, please send mail to webmaster@kernel.org.

also from www.kernel.org:
Please don't use finger.kernel.org for any sort of automatic monitoring. The number of automatic bots hitting this port is causing the finger daemon to shut down more often than not. The same information is available from http://www.kernel.org/kdist/finger_banner.

and of course the finger_banner file is not up to date.

You may consider using my http://www.xenotime.net/linux/scripts/kcurrent script.
Its output (today) is:

The latest stable version of the Linux kernel is:           2.6.30.4
The latest prepatch for the stable Linux kernel tree is:    2.6.31-rc5
The latest 2.4 version of the Linux kernel is:              2.4.37.4
The latest 2.2 version of the Linux kernel is:              2.2.26
The latest prepatch for the 2.2 Linux kernel tree is:       2.2.27-rc2
The latest -mm patch to the stable Linux kernels is:        2.6.28-rc2-mm1
mmotm-2009-0730-0501 ... applies to: 2.6.31-rc4
next-20090731 ... applies to: v2.6.31-rc4


---
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
