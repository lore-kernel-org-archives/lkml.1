Return-Path: <linux-kernel-owner+w=401wt.eu-S1753595Ab0AQJ0u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753595Ab0AQJ0u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 04:26:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751812Ab0AQJ0t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 04:26:49 -0500
Received: from lo.gmane.org ([80.91.229.12]:33592 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753507Ab0AQJ0s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 04:26:48 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: matthieu castet <castet.matthieu@free.fr>
Subject: Re: Ubuntu 32-bit, 32-bit PAE, 64-bit Kernel Benchmarks
Date: Sun, 17 Jan 2010 09:26:22 +0000 (UTC)
Message-ID: <loom.20100117T102152-191@post.gmane.org>
References: <SNT125-W41CEF6892DBE0B1FD99B4AC3780@phx.gbl>,<4B511B12.6010208@zytor.com> <SNT125-W39A63687E4BE4F52FAA517C3680@phx.gbl> <4B514656.5080805@zytor.com> <hisupj$hdn$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 81.57.151.96 (Mozilla/5.0 (X11; U; Linux i686; fr; rv:1.9.1.6) Gecko/20091215 Ubuntu/9.10 (karmic) Firefox/3.5.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> > Unfortunately Linux distros have not
> > properly promoted 64-bit kernels for 32-bit distros; although pure 64
> > bits is better, it would be a *helluva* lot better if people stuck on 32
> > bits for compatibility reasons had a saner alternative.
> > 
> IIRC Fedora actually planned to offer that and dropped it. There seem to be 
> display issues, I would assume the X stuff would have to match the kernel, 
> although I'm basing that on reports. The only split I ever tried was text only.
> 
Debian got a 64 bits kernel on the 32-bit distros. 2 years ago there where
display issue, but today it seems to works fine.
It is not the default kernel, but it is possible to use it.

But there is lot's of older cpu that doesn't support 64 bits, with more 1G of
RAM or that want NX support.

Matthieu

PS : there is even basic 64 bits library so you can run 64 bit application if
you want.

