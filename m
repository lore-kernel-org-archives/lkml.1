Return-Path: <linux-kernel-owner+w=401wt.eu-S934700AbZJJSkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934700AbZJJSkA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 14:40:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762046AbZJJSj6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 14:39:58 -0400
Received: from www.tglx.de ([62.245.132.106]:58454 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762078AbZJJSj6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 14:39:58 -0400
Date: Sat, 10 Oct 2009 20:38:38 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
cc: Jean Delvare <khali@linux-fr.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Vincent Sanders <vince@simtec.co.uk>, John Kacur <jkacur@redhat.com>,
       Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 23/28] i2c: Remove big kernel lock from i2cdev_open
In-Reply-To: <1255198531.7521.558.camel@laptop>
Message-ID: <alpine.LFD.2.00.0910102038060.9428@localhost.localdomain>
References: <20091010153314.827301943@linutronix.de>  <20091010153350.006406413@linutronix.de>  <20091010190436.1a48f98e@hyperion.delvare>  <alpine.LFD.2.00.0910101907420.9428@localhost.localdomain>  <20091010193915.0e34f0e9@hyperion.delvare> 
 <alpine.LFD.2.00.0910102010180.9428@localhost.localdomain> <1255198531.7521.558.camel@laptop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Oct 2009, Peter Zijlstra wrote:

> On Sat, 2009-10-10 at 20:10 +0200, Thomas Gleixner wrote:
> > 
> > > Will do. I guess I can assume that the patch is from Vincent Sanders,
> > > not you, despite the lack of From: header?
> > 
> > Duh, yes. Missed that.
> 
> I'm still wanting to fix quilt mail to not mess that up... maybe I
> should sit down and try and grok that stuff again.

IIRC it worked some time ago. That's why I did not notice.

Thanks,

	tglx
 
