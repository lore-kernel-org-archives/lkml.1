Return-Path: <linux-kernel-owner+w=401wt.eu-S1756141AbXKDTD0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141AbXKDTD0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 14:03:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753744AbXKDTDS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 14:03:18 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:44447 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559AbXKDTDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 14:03:17 -0500
Date: Sun, 4 Nov 2007 14:01:59 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Marco Costalba <mcostalba@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: List of possible duplicated include files in include/
In-Reply-To: <e5bfff550711041052m1c55571bx49c60dd6ce407d01@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0711041357310.23176@localhost.localdomain>
References: <e5bfff550711041044p7c07c42g836461e81a6005a@mail.gmail.com> 
 <Pine.LNX.4.64.0711041347001.12818@localhost.localdomain>
 <e5bfff550711041052m1c55571bx49c60dd6ce407d01@mail.gmail.com>
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

On Sun, 4 Nov 2007, Marco Costalba wrote:

> On 11/4/07, Robert P. J. Day <rpjday@crashcourse.ca> wrote:
> > On Sun, 4 Nov 2007, Marco Costalba wrote:
> >
> > > Here the number of false positives is overhelming, but perhaps
> > > there are also _real_ duplicated include somewhere in the bunch:
> > >
> > > include/acpi/acpi_bus.h:
> > > #include <linux/device.h>
> >
> > ... snip header file output ...
> >
> > i deliberately left out header files from my script output.  i can
> > tweak the script and add this to the web page as well.
> >
>
> Here the real job is to fliter out false positives more then print
> out the list I would say ;-)

  i don't think there are a lot of false positives there and, in any
event, it's a case of diminishing returns -- if you can get most of
what you want with two minutes of quick-and-dirty scripting, there's
not much point in spending another 10 or 15 minutes trying to tidy
things up only a little.

  just my $0.02 canadian, which is finally worth more than $0.02
american.  :-)

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
