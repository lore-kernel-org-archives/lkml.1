Return-Path: <linux-kernel-owner+w=401wt.eu-S1756830AbXIZL45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756830AbXIZL45 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 07:56:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751758AbXIZL4t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 07:56:49 -0400
Received: from hawking.rebel.net.au ([203.20.69.83]:34385 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbXIZL4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 07:56:49 -0400
Message-ID: <46FA48FC.4030602@davidnewall.com>
Date: Wed, 26 Sep 2007 21:26:44 +0930
From: David Newall <david@davidnewall.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Al Viro <viro@ftp.linux.org.uk>, Phillip Susi <psusi@cfl.rr.com>,
       Bill Davidsen <davidsen@tmr.com>, majkls <majkls@prepere.com>,
       bunk@fs.tum.de, linux-kernel@vger.kernel.org
Subject: Re: sys_chroot+sys_fchdir Fix
References: <46F0CD96.9030807@prepere.com>	<20070919104018.3a6bcfb1@the-village.bc.nu>	<46F16A0A.3070402@tmr.com>	<20070919194559.36015307@the-village.bc.nu>	<46F1A196.8060108@davidnewall.com>	<46F401D6.6060609@cfl.rr.com>	<20070921191012.15a0b51b@the-village.bc.nu>	<46F9752C.5080807@cfl.rr.com>	<20070926002340.GL8181@ftp.linux.org.uk>	<46FA35A6.1070400@davidnewall.com>	<20070926122127.74cdd000@the-village.bc.nu>	<46FA40F3.8010306@davidnewall.com> <20070926123833.2ed598af@the-village.bc.nu>
In-Reply-To: <20070926123833.2ed598af@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> Now see I've been working on Unix systems since 1988 or so and in that
> time I've learned to read the documentation properly (you haven't)

My, my, you can be unpleasant when you try.  There's no need for it.  As 
it happens I have years of UNIX experience on you.  (Newbie!)

You've got an idea that the original intention was for there to be a way 
to escape from a chroot, but that the documentation was written so that, 
not only was this not mentioned, but what was written implies 
otherwise.  You've also got some idea that because it's the way it is, 
therefore it must be right.  You present no reasoning to explain why the 
behavior is correct; instead you use insults.  I've exhausted my 
tolerance for rudeness.
