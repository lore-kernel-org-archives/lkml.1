Return-Path: <linux-kernel-owner+w=401wt.eu-S1758773AbYBGKf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758773AbYBGKf2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 05:35:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755236AbYBGKfN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 05:35:13 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:39877 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755160AbYBGKfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 05:35:10 -0500
Date: Thu, 7 Feb 2008 05:35:03 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Harvey Harrison <harvey.harrison@gmail.com>
cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jiri Slaby <jirislaby@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: feature-removal-schedule.txt is getting out of date again
In-Reply-To: <1202327360.5820.24.camel@brick>
Message-ID: <alpine.LFD.1.00.0802070533190.20096@localhost.localdomain>
References: <alpine.LFD.1.00.0802060419140.17178@localhost.localdomain>  <200802062054.59755.bzolnier@gmail.com> <1202327360.5820.24.camel@brick>
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

On Wed, 6 Feb 2008, Harvey Harrison wrote:

> On Wed, 2008-02-06 at 20:54 +0100, Bartlomiej Zolnierkiewicz wrote:
> > Hi,
> >
> > On Wednesday 06 February 2008, Robert P. J. Day wrote:
> > >
> > >   yes, i realize i'm sounding like a broken record but, once again,
> > > Documentation/feature-removal-schedule.txt is slipping out of date WRT
> > > items that are now slightly, if not noticeably, behind schedule for
> > > removal.
> >
>
> I had pinged people about a week ago on lots of these items, for the
> most part patches are staged and going in through various trees,
> let's wait for rc1 and see what has landed by then.

ah, i had no idea that things were in the pipeline.  that's always
good to know but, still, it's not a bad idea to keep the info in the
features removal file as least *vaguely* up to date.  at the very
least, if something seems to be more than a year behind schedule for
removal, then a small addendum to that item in that file by way of
explanation might be in order.

rday
--



========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

Home page:                                         http://crashcourse.ca
Fedora Cookbook:    http://crashcourse.ca/wiki/index.php/Fedora_Cookbook
========================================================================
