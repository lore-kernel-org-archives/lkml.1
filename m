Return-Path: <linux-kernel-owner+w=401wt.eu-S1756696AbXEUUgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696AbXEUUgV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 16:36:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754805AbXEUUgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 16:36:09 -0400
Received: from www.osadl.org ([213.239.205.134]:56091 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752100AbXEUUgH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 16:36:07 -0400
Subject: Re: v2.6.21-rt3
From: Thomas Gleixner <tglx@linutronix.de>
To: Daniel Walker <dwalker@mvista.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
In-Reply-To: <1179779142.15427.44.camel@imap.mvista.com>
References: <20070517194143.GA25394@elte.hu>
	 <1179778266.15427.38.camel@imap.mvista.com>
	 <1179779053.12708.45.camel@chaos>
	 <1179779142.15427.44.camel@imap.mvista.com>
Content-Type: text/plain
Date: Mon, 21 May 2007 22:36:05 +0200
Message-Id: <1179779765.12708.50.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-05-21 at 13:25 -0700, Daniel Walker wrote:
> On Mon, 2007-05-21 at 22:24 +0200, Thomas Gleixner wrote:
> > On Mon, 2007-05-21 at 13:11 -0700, Daniel Walker wrote:
> > > Where did the arm ep93xx changes come from? 
> > 
> > Grown out of my nose probably.
> > 
> > > It looks like patch below
> > > came in with them in 2.6.21-rt6 ..
> > 
> > So what ?
> 
> It's silencing a WARN_ON() with no real reason why it's happening, or
> why/if it's safe to silence it .. Why is that there?

Care to look at the code ? 

	tglx


