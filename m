Return-Path: <linux-kernel-owner+w=401wt.eu-S1754689AbXDZDGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689AbXDZDGS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 23:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754695AbXDZDGS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 23:06:18 -0400
Received: from mail.gmx.net ([213.165.64.20]:44496 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754689AbXDZDGR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 23:06:17 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18QxhALcioQZsjtcJtejgbZ3zNLaZdL1Dq+JVHyW4
	Eb/v44r/M6PKkW
Subject: Re: menuconfig issue (checklist) in 2.6.20.7 & 2.6.21-rc7 ?
From: Mike Galbraith <efault@gmx.de>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Sunil Naidu <akula2.shark@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20070425203009.GA15917@uranus.ravnborg.org>
References: <8355959a0704250724g3614d293h2dd08833a6ef473b@mail.gmail.com>
	 <20070425120730.4c267c15.akpm@linux-foundation.org>
	 <1177529517.6434.29.camel@Homer.simpson.net>
	 <20070425203009.GA15917@uranus.ravnborg.org>
Content-Type: text/plain
Date: Thu, 26 Apr 2007 05:06:14 +0200
Message-Id: <1177556774.6098.10.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-04-25 at 22:30 +0200, Sam Ravnborg wrote:

> > There are general funnies in the menuconfig world (my preference) here.
> > For instance, I recently had reason to change/test different default IO
> > schedulers, and found that no matter what I did, I couldn't select a
> > default IO scheduler any more, though I used to be able to do so.

> Tried it now with latest -git from Linus and here it works.
> Notice that you need to make the scheduler a built-in <*>
> before you can select it as default.
> A scheduler selected as a module <M> cannot be made default.

Ok, I guess my ncurses is ill.  (all built in)  Thanks.

	-Mike

