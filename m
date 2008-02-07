Return-Path: <linux-kernel-owner+w=401wt.eu-S932244AbYBGRcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932244AbYBGRcU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 12:32:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755624AbYBGRcB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 12:32:01 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:53228 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755570AbYBGRcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 12:32:00 -0500
Date: Thu, 7 Feb 2008 12:31:49 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jiri Slaby <jirislaby@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: feature-removal-schedule.txt is getting out of date again
In-Reply-To: <200802062054.59755.bzolnier@gmail.com>
Message-ID: <alpine.LFD.1.00.0802071231070.22432@localhost.localdomain>
References: <alpine.LFD.1.00.0802060419140.17178@localhost.localdomain> <200802062054.59755.bzolnier@gmail.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
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
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Feb 2008, Bartlomiej Zolnierkiewicz wrote:

> Robert, I suggest that you just send patches removing outdated items (probably
> starting with the one below like you tried in the past) and be quite stubborn
> about it (otherwise you can be pretty sure that nothing will happen)...
>
> ...
> What:   PCMCIA control ioctl (needed for pcmcia-cs [cardmgr, cardctl])
> When:   November 2005
> ....
>
> http://lkml.org/lkml/2007/5/1/107
>
> Christoph, 10 months later and this method doesn't seem to work.
>
> How's about disabling it in -mm and waiting for complaints instead
> (if none come just remove the code in 2.6.26-rc1)?
>
> [ Either this or we should just remove the item in question from
>   feature-removal-schedule.txt. ]

yes, i didn't see any followup on that item.  i still have the patch,
unless it's already working its way thru the system.

rday
--
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

Home page:                                         http://crashcourse.ca
Fedora Cookbook:    http://crashcourse.ca/wiki/index.php/Fedora_Cookbook
========================================================================
