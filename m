Return-Path: <linux-kernel-owner+w=401wt.eu-S1753095AbXCMF3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095AbXCMF3V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 01:29:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753126AbXCMF3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 01:29:20 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59186
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753095AbXCMF3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 01:29:20 -0400
Date: Mon, 12 Mar 2007 22:29:18 -0700 (PDT)
Message-Id: <20070312.222918.74750578.davem@davemloft.net>
To: w@1wt.eu
Cc: kernel@kolivas.org, linux-kernel@vger.kernel.org, ck@vds.kolivas.org
Subject: Re: RSDL v0.30 cpu scheduler for mainline kernels
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070313043206.GN943@1wt.eu>
References: <20070312.164652.108743760.davem@davemloft.net>
	<200703131405.23482.kernel@kolivas.org>
	<20070313043206.GN943@1wt.eu>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Willy Tarreau <w@1wt.eu>
Date: Tue, 13 Mar 2007 05:32:07 +0100

> On Tue, Mar 13, 2007 at 02:05:23PM +1100, Con Kolivas wrote:
> > On Tuesday 13 March 2007 10:46, David Miller wrote:
> > > From: Con Kolivas <kernel@kolivas.org>
> > > Date: Mon, 12 Mar 2007 10:58:11 +1100
> > >
> > > > http://ck.kolivas.org/patches/staircase-deadline/2.6.21-rc3-sched-rsdl-0.
> > > >30.patch
> > >
> > > FWIW, this boots and seems to work well on sparc64.  Tested
> > > on UP SunBlade1500 and 24cpu Niagara T1000.
> > 
> > Very nice. Thanks for the feedback and I'm sorry you have to work with such 
> > lousy hardware.
> 
> BTW, I don't know if you say this as a joke,

He was definitely being sarcastic, relax :-)

