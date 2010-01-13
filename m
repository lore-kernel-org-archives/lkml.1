Return-Path: <linux-kernel-owner+w=401wt.eu-S1754892Ab0AMNUM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892Ab0AMNUM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 08:20:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754838Ab0AMNUK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 08:20:10 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:37651 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754811Ab0AMNUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 08:20:09 -0500
Date: Wed, 13 Jan 2010 08:19:20 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost
To: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@stericsson.com>,
       sameo@linux.intel.com, Reinhard.Tartler@informatik.uni-erlangen.de
Subject: Re: [PATCH] typo in kernel source (DEBUGFS)
In-Reply-To: <20100113131539.GA3141@stud.informatik.uni-erlangen.de>
Message-ID: <alpine.LFD.2.00.1001130815530.13515@localhost>
References: <20100113115712.GA7398@faui49.informatik.uni-erlangen.de> <alpine.LFD.2.00.1001130704190.532@localhost> <20100113131539.GA3141@stud.informatik.uni-erlangen.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
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

On Wed, 13 Jan 2010, Christoph Egger wrote:

> On Wed, Jan 13, 2010 at 07:05:33AM -0500, Robert P. J. Day wrote:
> >
> >   just FYI, the same information can be found where i post the
> > output from my kernel scanning scripts.  specifically, that very
> > typo is already documented here:
> >
> > http://www.crashcourse.ca/wiki/index.php/Badref_CONFIG_variables#mfd
> >
> > rday
>
> 	Jep I stumbled upon your reports while having a closer look at
> what we found. Strangely while you did find somewhere around 250
> such Issues we are at 90[0] if you count #define-ed CONFIG_* to the
> errors. I'll probably try to look at the difference between our
> results.
>
> [0] http://vamos1.informatik.uni-erlangen.de/graph.html

  it's entirely possible that i have false positives in my listings;
anyone who wants to look at them is responsible for checking them out
more carefully, but i believe i catch most of the errors.

rday
--

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

            Linux Consulting, Training and Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Twitter:                                       http://twitter.com/rpjday
========================================================================
