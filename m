Return-Path: <linux-kernel-owner+w=401wt.eu-S965285AbXBQPAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965285AbXBQPAh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 10:00:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965287AbXBQPAh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 10:00:37 -0500
Received: from [212.12.190.178] ([212.12.190.178]:32938 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S965285AbXBQPAg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 10:00:36 -0500
From: Al Boldi <a1426z@gawab.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [patch 05/11] syslets: core code
Date: Sat, 17 Feb 2007 17:57:56 +0300
User-Agent: KMail/1.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702171757.56364.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Evgeniy Polyakov wrote:
> Ray Lee (ray-lk@madrabbit.org) wrote:
> > The truth of this lies somewhere in the middle. It isn't kernel driven,
> > or userspace interface driven, but a tradeoff between the two.
> >
> > So:
> > > Userspace_API_is_the_ever_possible_last_thing_to_ever_think_about.
> > > Period
> >
> > Please listen to those of us who are saying that this might not be the
> > case. Maybe we're idiots, but then again maybe we're not, okay?
> > Sometimes the API really *DOES* change the underlying implementation.
>
> It is exactly the time to say what interface sould be good.
> System is almost ready - it is time to make it looks cool for users.

IMHO, what is needed is an event registration switch-board that handles 
notifications from the kernel and the user side respectively.


Thanks!

--
Al

