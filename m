Return-Path: <linux-kernel-owner+w=401wt.eu-S1759781AbXFRGJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759781AbXFRGJz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 02:09:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755000AbXFRGJq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 02:09:46 -0400
Received: from srv1.netkinetics.net ([206.71.148.180]:51637 "EHLO
	srv1.netkinetics.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754974AbXFRGJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 02:09:45 -0400
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
From: Tim Post <tim.post@netkinetics.net>
Reply-To: tim.post@netkinetics.net
To: Gabor Czigola <czigola@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <3a0f49600706171014m6bc9af34s9dda0ea282a4d63@mail.gmail.com>
References: <3a0f49600706171014m6bc9af34s9dda0ea282a4d63@mail.gmail.com>
Content-Type: text/plain
Organization: Net Kinetics
Date: Mon, 18 Jun 2007 14:08:03 +0800
Message-Id: <1182146883.21796.1480.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.1 
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - srv1.netkinetics.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [0 0] / [47 12]
X-AntiAbuse: Sender Address Domain - netkinetics.net
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-06-17 at 19:14 +0200, Gabor Czigola wrote:
> Hello!
> 
> I didn't follow the whole thread from the beginning, but I see that
> there are pros and cons for both versions of GPL.
> 
> I wonder why the linux kernel development community couldn't propose
> an own GPL draft (say v2.2) that is "as free as v2" and that includes
> some ideas (from v3) that are considered as good (free, innovative, in
> the spirit of whatever etc.) by the majority of the kernel developers.
> 
> I guess to have an own version of the GPL license could also help to
> resolve (future) dual-licensing problems.
> 
> Gabor Czigola

They very well could. There are provisions (I had to dig through
gnu.org) to find them, but you are perfecly O.K. to take the legal terms
of the GPL and make them your own in your own license. You can't copy
their preamble without permission, and it can have no mention of GNU in
the license once you finish.

The issue would be compatibility. You can't have licenses fighting each
other in your project, undesirable effects could include not being able
to merge with code that remains under the original license. 

The popularity of GPL2 would make this rather impractical, but if this
is no issue to you then there is no problem.

In a kernel, its a big problem.

Best,
--Tim


