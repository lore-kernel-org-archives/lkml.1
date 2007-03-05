Return-Path: <linux-kernel-owner+w=401wt.eu-S932966AbXCEP1e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932966AbXCEP1e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 10:27:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932963AbXCEP1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 10:27:34 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:39476 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932914AbXCEP1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 10:27:33 -0500
Subject: Re: [5/6] 2.6.21-rc2: known regressions
From: Daniel Walker <dwalker@mvista.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Emil Karlson <jkarlson@cc.hut.fi>,
       "Michael S. Tsirkin" <mst@mellanox.co.il>,
       Soeren Sonnenburg <kernel@nn7.de>
In-Reply-To: <20070305001358.2eebbfae.akpm@linux-foundation.org>
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org>
	 <20070305015040.GJ3441@stusta.de> <20070305075747.GA19838@elte.hu>
	 <20070305001358.2eebbfae.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Mon, 05 Mar 2007 07:25:03 -0800
Message-Id: <1173108303.31337.18.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-05 at 00:13 -0800, Andrew Morton wrote:
> On Mon, 5 Mar 2007 08:57:47 +0100 Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * Adrian Bunk <bunk@stusta.de> wrote:
> > 
> > > Subject    : i386: no boot with nmi_watchdog=1  (clockevents)
> > > References : http://lkml.org/lkml/2007/2/21/208
> > > Submitter  : Daniel Walker <dwalker@mvista.com>
> > > Caused-By  : Thomas Gleixner <tglx@linutronix.de>
> > >              commit e9e2cdb412412326c4827fc78ba27f410d837e6e
> > > Handled-By : Thomas Gleixner <tglx@linutronix.de>
> > > Status     : problem is being debugged
> > 
> > FYI, this is not a "wont boot" problem, this should be a "NMI watchdog 
> > does not work" problem - which has far lower severity. Also, Thomas did 
> > a fix for this which is now in -mm.
> >
> 
> yup, you should be able to cross this one off, Adrian.  The fix worked for me,
> at least.

I didn't see a fix for this one go by .. I'll check the usual places I
guess ..

Daniel

