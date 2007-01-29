Return-Path: <linux-kernel-owner+w=401wt.eu-S1751581AbXA2OeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751581AbXA2OeQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 09:34:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751584AbXA2OeQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 09:34:16 -0500
Received: from stat-62-123-231-21.atlanet.it ([62.123.231.21]:48410 "EHLO
	ns.studiotreccani.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751575AbXA2OeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 09:34:15 -0500
X-Greylist: delayed 1528 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Jan 2007 09:34:15 EST
Date: Mon, 29 Jan 2007 15:08:44 +0100
From: Andrea Gelmini <gelma@gelma.net>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: VM: Fix nasty and subtle race in shared mmap'ed page writeback
Message-ID: <20070129140844.GE8271@gelma.net>
References: <459C7B24.8080008@yahoo.com.au> <Pine.LNX.4.64.0701032031400.3661@woody.osdl.org> <20070103214121.997be3e6.akpm@osdl.org> <459C98BF.5080409@yahoo.com.au> <20070104131612.GC28470@gelma.net> <459DE3C6.20302@yahoo.com.au> <20070110135453.GH7947@gelma.net> <1168507298.26496.18.camel@twins> <20070112003955.GH4553@gelma.net> <1169457039.2639.17.camel@taijtu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1169457039.2639.17.camel@taijtu>
Weight: 75 kg (165.346697 lbs)
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 22, 2007 at 10:10:39AM +0100, Peter Zijlstra wrote:
> On Fri, 2007-01-12 at 01:39 +0100, Andrea Gelmini wrote:
> > Hi,
> > 	I can't do the test 'till next week.
> > 
> > Thanks a lot for your time,
> > Gelma
> 
> Have you ever gotten around to testing this?

well, I spent some time doing more deeply test.
DB corruption happens anyway, even with the kernel that seems to work
(I say seems because it needs much more effort to get corruption).
I'm trying to understand it.
I will work more over it next week.

thank a lot for your time,
gelma
