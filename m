Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342Ab0CBTVi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 14:21:38 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:40481 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751363Ab0CBTVh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 14:21:37 -0500
Date: Tue, 2 Mar 2010 20:21:35 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: walt <w41ter@gmail.com>, linux-kernel@vger.kernel.org,
       Michael Breuer <mbreuer@majjas.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>, dmonakhov@openvz.org
Subject: Re: [GIT PULL] single block IO revert (Was "Re: Oops while booting
	2.6.34-rc0 (block pull busted)")
Message-ID: <20100302192135.GA5768@kernel.dk>
References: <201003011615.31709.dmitry.torokhov@gmail.com> <20100302075656.GO5768@kernel.dk> <20100302081547.GP5768@kernel.dk> <hmiocs$p6h$1@dough.gmane.org> <4B8D41C7.1030404@majjas.com> <20100302174250.GA13131@goodmis.org> <20100302174939.GB13131@goodmis.org> <20100302182117.GW5768@kernel.dk> <1267557422.10871.23.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267557422.10871.23.camel@gandalf.stny.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 02 2010, Steven Rostedt wrote:
> On Tue, 2010-03-02 at 19:21 +0100, Jens Axboe wrote:
> > On Tue, Mar 02 2010, Steven Rostedt wrote:
> 
> > 
> > We'll revert it asap, no point in wasting time debugging it first.
> 
> Thanks!
> 
> Since I have a box that triggers this issue, let me know if there's a
> git branch you would like me to test.

Thanks, will let you know!

-- 
Jens Axboe

