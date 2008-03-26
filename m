Return-Path: <linux-kernel-owner+w=401wt.eu-S1760079AbYCZNXy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760079AbYCZNXy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 09:23:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754650AbYCZNXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 09:23:47 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:54508 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943AbYCZNXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 09:23:46 -0400
Date: Wed, 26 Mar 2008 09:23:43 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: David Woodhouse <dwmw2@infradead.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: why so many unexported headers checking __KERNEL__?
In-Reply-To: <1206537586.9540.280.camel@pmac.infradead.org>
Message-ID: <alpine.LFD.1.00.0803260922420.6408@localhost.localdomain>
References: <alpine.LFD.1.00.0803230229530.1203@localhost.localdomain>  <1206533324.9540.268.camel@pmac.infradead.org>  <alpine.LFD.1.00.0803260846390.6148@localhost.localdomain>  <1206537022.9540.274.camel@pmac.infradead.org> 
 <alpine.LFD.1.00.0803260913350.6316@localhost.localdomain> <1206537586.9540.280.camel@pmac.infradead.org>
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

On Wed, 26 Mar 2008, David Woodhouse wrote:

> On Wed, 2008-03-26 at 09:16 -0400, Robert P. J. Day wrote:
> > well, since i already have the output from my script, i might toss
> > together some per-directory patches to start removing some of
> > that. this sounds more like a one-shot thing than adding permanent
> > checking to the build process.
>
> Makes sense.
>
> Remember, one of our goals is to move towards having files which are
> just _copied_ (header-y) instead of having these ifdefs. If, in your
> travels, you see a way you can split headers up more sensibly to
> achieve that, it would be good.

that might be harder to encode into a script.  :-)

rday
--

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
