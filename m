Return-Path: <linux-kernel-owner+w=401wt.eu-S1759039AbXK1J6x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759039AbXK1J6x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 04:58:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755614AbXK1J6n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 04:58:43 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:40868 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754685AbXK1J6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 04:58:42 -0500
Date: Wed, 28 Nov 2007 04:56:42 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: murtuja bharmal <murtuja_bharmal@yahoo.com>
cc: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
       linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: Re: Linux 2.6 kernel module compilation without using KBUILD
In-Reply-To: <180651.51647.qm@web36715.mail.mud.yahoo.com>
Message-ID: <alpine.LFD.0.9999.0711280453330.3612@localhost.localdomain>
References: <180651.51647.qm@web36715.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Nov 2007, murtuja bharmal wrote:

> Hello Sam,
>
> My intention is to just understand whole process of making kernel
> module. Actually I am working on one project in which I have to port
> lots of 2.4 kernel module in 2.6 kernel. So I thought lets first try
> to understand, what is going behind KBUILD. I also gone through
> linux/Documentation/kbuild/ but didn't get very much information.
> Even after running it on Verbose Mode, I am not very much clear.
>
> Thanks
> Murtuja Bharmal

you'd probably be better off asking this on the kernel newbies list
rather than the main kernel list.  and, as an intro to porting 2.4 to
2.6 modules, you might want to start here:

http://lwn.net/Articles/driver-porting/

and, as others have suggested, you're probably better off just
figuring out the 2.6 kbuild structure.  trying to do this manually
without kbuild is just making this way more difficult than it has to
be.

rday

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
