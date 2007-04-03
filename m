Return-Path: <linux-kernel-owner+w=401wt.eu-S934043AbXDCXoD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934043AbXDCXoD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 19:44:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030224AbXDCXoD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 19:44:03 -0400
Received: from smtp.ono.com ([62.42.230.12]:26849 "EHLO resmaa03.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934043AbXDCXoB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 19:44:01 -0400
Date: Wed, 4 Apr 2007 01:43:13 +0200
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: Valdis.Kletnieks@vt.edu
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net
Subject: Re: 2.6.21-rc5-mm4
Message-ID: <20070404014313.66ca1f99@werewolf-wl>
In-Reply-To: <17464.1175642567@turing-police.cc.vt.edu>
References: <20070402224745.71a25af7.akpm@linux-foundation.org>
	<20070404004005.2f21d514@werewolf-wl>
	<20070403155135.ff7f3043.akpm@linux-foundation.org>
	<20070404005826.5c849ab6@werewolf-wl>
	<17464.1175642567@turing-police.cc.vt.edu>
X-Mailer: Claws Mail 2.8.1cvs80 (GTK+ 2.10.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 03 Apr 2007 19:22:47 -0400, Valdis.Kletnieks@vt.edu wrote:

> On Wed, 04 Apr 2007 00:58:26 +0200, "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" said:
> 
> > Anyways, I have just remembered I use the (in)famous nVidia driver.
> > Will try to reproduce without it. This was more like a probe to see if
> > somebody else is suffering it...
> 
> The nVidia driver will get some truly astounding indigestion if you accidentally
> upgrade your xorg userspace libraries and forget to re-install the nVidia
> userspace.  Is that what's biting you?
> 

No, in my distro (mandriva), libraries and drivers from ndivia are in different
places so they don't get overriden in xorg reinstall. Use is controlled
with ld.so.conf and ModulePath.
In fact, X works fine until the saver plays on...

--
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2007.1 (Cooker) for i586
Linux 2.6.20-jam08 (gcc 4.1.2 20070302 (prerelease) (4.1.2-1mdv2007.1)) #1 SMP PREEMPT
