Return-Path: <linux-kernel-owner+w=401wt.eu-S965662AbXCLL0D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965662AbXCLL0D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 07:26:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965663AbXCLL0D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 07:26:03 -0400
Received: from mail.gmx.net ([213.165.64.20]:45210 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S965662AbXCLL0A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 07:26:00 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19CGPYZknBCbCUBYblxP2ukvqb6gpc9KVNSPKRqvP
	WYTOfCrSBxbCit
Subject: Re: [PATCH][RSDL-mm 0/7] RSDL cpu scheduler for 2.6.21-rc3-mm2
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Con Kolivas <kernel@kolivas.org>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20070312110833.GA12835@elte.hu>
References: <200703111457.17624.kernel@kolivas.org>
	 <200703122022.43021.kernel@kolivas.org>
	 <1173692286.20540.12.camel@Homer.simpson.net>
	 <200703122127.41942.kernel@kolivas.org>
	 <1173697024.8014.19.camel@Homer.simpson.net>
	 <20070312110833.GA12835@elte.hu>
Content-Type: text/plain
Date: Mon, 12 Mar 2007 12:25:57 +0100
Message-Id: <1173698757.8014.28.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-12 at 12:08 +0100, Ingo Molnar wrote:
> * Mike Galbraith <efault@gmx.de> wrote:
> 
> > The test scenario was one any desktop user might do with every 
> > expectation responsiveness of the interactive application remain 
> > intact. I understand the concepts here Con, and I'm not knocking your 
> > scheduler. I find it to be a step forward on the one hand, but a step 
> > backward on the other.
> 
> ok, then that step backward needs to be fixed.

btw, this scenario wasn't invented by me, it came from the _every single
day_ usage of my best friend since his conversion to linux (he's in love
now;) a month ago.  After I un-crippled all of the multimedia apps that
came with our distribution, this is the thing he has been doing most.

	-Mike

