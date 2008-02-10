Return-Path: <linux-kernel-owner+w=401wt.eu-S1756676AbYBJMc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756676AbYBJMc6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 07:32:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755544AbYBJMct
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 07:32:49 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:53074 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754986AbYBJMcs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 07:32:48 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [Regression] 2.6.24-git9: RT sched mishandles artswrapper (bisected)
Date: Sun, 10 Feb 2008 13:30:37 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>
References: <200802010237.59320.rjw@sisk.pl> <200802070031.03955.rjw@sisk.pl> <20080206233434.GA12393@elte.hu>
In-Reply-To: <20080206233434.GA12393@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802101330.37559.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 7 of February 2008, Ingo Molnar wrote:
> 
> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > > http://programming.kicks-ass.net/kernel-patches/sched-rt-group/
> > > 
> > > on top of sched-devel.
> > 
> > Indeed, with these patches applied the issue is not reproducible any 
> > more.
> 
> great! I've queued Peter's fixes and enhancements up in sched-devel. 
> (not pushed out yet)

Could you please tell me what's happening to these patches?

The regression is still present in the current mainline and it would be a pity
if -rc1 went out with it.

Thanks,
Rafael
