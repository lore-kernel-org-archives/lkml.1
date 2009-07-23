Return-Path: <linux-kernel-owner+w=401wt.eu-S1753897AbZGWUE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897AbZGWUE3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 16:04:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753047AbZGWUE2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 16:04:28 -0400
Received: from mail.gmx.net ([213.165.64.20]:58477 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753032AbZGWUE2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 16:04:28 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19jqPws5ppjkE9IKdU8olFzvdFCKOFVuO0JPCevop
	D1KKsoMsksbZBf
Subject: Re: [patch] perf_counter tools: resurrect perf top annotation in a
 simple interactive form
From: Mike Galbraith <efault@gmx.de>
To: Ray Lee <ray-lk@madrabbit.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <2c0942db0907230859j13cf14bcl179e883fe5d990c8@mail.gmail.com>
References: <1248090981.18702.14.camel@marge.simson.net>
	 <1248274190.27058.1530.camel@twins>
	 <1248281171.5738.5.camel@marge.simson.net>
	 <1248287763.8266.15.camel@marge.simson.net>
	 <1248331306.13472.25.camel@marge.simson.net>
	 <2c0942db0907230859j13cf14bcl179e883fe5d990c8@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 23 Jul 2009 22:04:24 +0200
Message-Id: <1248379464.5900.14.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-23 at 08:59 -0700, Ray Lee wrote:
> On Wed, Jul 22, 2009 at 11:41 PM, Mike Galbraith <efault@gmx.de> wrote:
> > > Hm, that is lame though, so updated patch below.  If an unknown key is
> > > poked, display known keys, and wait for the user to poke one that _is_
> > > known.  If you know the keys, you don't have to look at annoying legend,
> > > if you forget, tap space or whatever.
> >
> > I leered at it again this morning, and changed it a wee bit more.
> > Hitting an unknown key displays keys and current settings, and prompts
> > for input.  Hitting space allows you to cancel entry.
> 
> Whenever I get a menu I didn't want, my finger reaches for ESC of its
> own volition. Just a thought.

Good thought (intuitive).  Adds to cleanup good intentions list ;-)

	-Mike

