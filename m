Return-Path: <linux-kernel-owner+w=401wt.eu-S1752389AbYI2EDb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389AbYI2EDb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 00:03:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750745AbYI2EDY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 00:03:24 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:37927 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712AbYI2EDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 00:03:23 -0400
Message-ID: <49203.166.70.238.43.1222658858.squirrel@webmail.wolfmountaingroup.com>
In-Reply-To: <20080929015730.GK8711@mit.edu>
References: <33521.166.70.238.43.1222622153.squirrel@webmail.wolfmountaingroup.com>
    <20080928194536.GC8711@mit.edu>
    <20080928194616.10d25760@bree.surriel.com>
    <58677.166.70.238.43.1222644857.squirrel@webmail.wolfmountaingroup.com>
    <20080929015730.GK8711@mit.edu>
Date: Sun, 28 Sep 2008 21:27:38 -0600 (MDT)
Subject: Re: [REQUEST] Clarification from Copyright Holders on 
     FUSE/NDISWRAPPER
From: jmerkey@wolfmountaingroup.com
To: "Theodore Tso" <tytso@mit.edu>, jmerkey@wolfmountaingroup.com,
       "Rik van Riel" <riel@redhat.com>, linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> You may find these research reports interesting:
>
> http://www.linuxfoundation.org/publications/linuxkerneldevelopment.php
> http://www.linux-foundation.org/publications/IDC_Workloads.pdf
>
> The former shows that the development rate is if anything, increasing
> based on analyzing the rate that changes are flowing into the Linus's
> git tree --- something which I think everyone would agree is a better
> way of measuring the rate of development than the number of downloads
> of mdb.
>
> The latter is a report from IDC which calculates total enterprise
> spending in the Linux ecosystem at $21 billion in 2007, and predicts
> that by 2011 the figure will more than double to $49 billion.
>
> So the health of Linux, both in terms of the rate of development and
> the enterprise server ecosystem, seems to be doing quite well (never
> mind the surge of interest of Linux for mobile platforms).  But if you
> want to develop on FreeBSD, hey, don't let us stop you.  Different
> licensing strokes for different folks, after all...
>
> Regards,
>
> 						- Ted
>

Hi Ted,

The figures I am quoting are based on who is downloading not how many.  I
had over 27,000 downloads the first week but only a few of them were from
fortune 1000 of 500 companies.  After two weeks it dropped off sharply to
a very low level.  Most of the downloads are still from my primary
servers, and not google or sourceforge.  I agree Linux is pervasive and
its use is increasing among the US customer base, but its interest from
technology companies (distributors) is declining.

This is usually the first sign.  You have to remember, I was at Novell in
its heyday and I watched the trends.  Novell's customer base was steadily
increasing long after the company lost its lead and started its decline. 
The first sign is lack of interest in new development, not lack of
interest in using it.   This is reflected in the lack of innovation
occurring at present in Linux (how many ways can you serve up unix?).

The numbers you are quoting are tied to hardware sales and deployment
where software is just some free gizmo tossed on the server -- I do not
consider them representative of Linux itself.

The GPL and its advantages for the success of Linux can be liked to the
theory of http://en.wikipedia.org/wiki/Antagonistic_pleiotropy_hypothesis
in biology.  The GPL conferred distinct advantages to Linux its early
development but now that the platform is mature, it is manifesting in
other ways --most of them deleterious.  Who wants to develop software
under the GPL for commercial use when you have people who sit around on
their ass and file lawsuits (I should talk) against people using for
example busybox so they can be lazy and extort money out of folks?  That's
where GPL in general seems to be headed.  I cannot convince any investors
to put a plug nickle into Linux anymore because there's no profit model
that works for software only businesses or even hardware businesses if you
add technology.  The danger of a rabid FSF lawsuit is too great.

Don't get me wrong, I love working on Linux and the debugger, but I think
its ill advised to use it in any commercial venture where proprietary
technology is being developed -- it's risky these days.

:-)

Jeff





