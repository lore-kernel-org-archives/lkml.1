Return-Path: <linux-kernel-owner+w=401wt.eu-S1755019AbZFDPl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755019AbZFDPl2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 11:41:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755942AbZFDPlR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 11:41:17 -0400
Received: from mx-out.daemonmail.net ([216.104.160.38]:51757 "EHLO
	mx-out.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755687AbZFDPlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 11:41:16 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.30-rc8 [also: VIA Support]
Date: Thu, 4 Jun 2009 10:37:46 -0500
User-Agent: KMail/1.9.9
References: <alpine.LFD.2.01.0906022055030.4880@localhost.localdomain> <200906040958.46018.lkml@morethan.org> <alpine.LFD.2.01.0906040817090.4880@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0906040817090.4880@localhost.localdomain>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Harald Welte <HaraldWelte@viatech.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906041037.50461.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu June 4 2009, you wrote:
> 
> On Thu, 4 Jun 2009, Michael S. Zick wrote:
> > 
> > Well, that one isn't anything to brag about"
> 
> So what's the problem on that machine? Is the VIA C7-M (or some random 
> device in it) just buggy and it eventually hangs, or what? Has _any_ 
> kernel ever worked on that machine for longer than an hour or two?
> 

It is not (directly) the C7-M - it might be the chipset CX700.

I have a small pool (5 or so actively reporting) testers -

On the Everex Cloudbook (C7-M/CX700) I have gotten a record
of 4h45 minutes of up-time on some, locally patched, builds.
The same is reported on other Everex Cloudbooks.

On the Sylvania gBook (also C7-M/CX700) the user reports
10s of minutes as their record up-time.

H.W. got hold of one of the companies demo-boards but I
haven't heard back from him yet on his experiences.

On the HP-2133 (C7-M/CN896) the uptime is unknown - -
only greater than 12 hours (it has never/ever deadlocked).

I also have a couple of technical questions pending
with H.W. for the silicon grower's department.
No response yet.

- - - -

But you asked for "testing" - hence this post.

Mike

> 		Linus
> 
> 


