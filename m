Return-Path: <linux-kernel-owner+w=401wt.eu-S933646AbXCQF4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933646AbXCQF4S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 01:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933674AbXCQF4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 01:56:18 -0400
Received: from mail.gmx.net ([213.165.64.20]:41199 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933671AbXCQF4R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 01:56:17 -0400
X-Provags-ID: V01U2FsdGVkX1+OwKBjKgqOTBbalzG9c/El0W8SwIIEKen4608GHM
	e3zUy8Hjnh9JFN
Subject: Re: RSDL v0.31
From: Mike Galbraith <efault@gmx.de>
To: Nicholas Miell <nmiell@comcast.net>
Cc: Con Kolivas <kernel@kolivas.org>, ck@vds.kolivas.org,
       Ingo Molnar <mingo@elte.hu>, Al Boldi <a1426z@gawab.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <1174105443.3144.4.camel@entropy>
References: <200703042335.26785.a1426z@gawab.com>
	 <200703170040.48316.kernel@kolivas.org>
	 <1174059299.7886.25.camel@Homer.simpson.net>
	 <200703170813.32594.kernel@kolivas.org>
	 <1174084207.7009.9.camel@Homer.simpson.net>
	 <1174105443.3144.4.camel@entropy>
Content-Type: text/plain
Date: Sat, 17 Mar 2007 06:56:05 +0100
Message-Id: <1174110965.7911.44.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-03-16 at 21:24 -0700, Nicholas Miell wrote:

> Sorry, I haven't really been following this thread and now I'm confused.
> 
> You're saying that it's somehow the scheduler's fault that X isn't
> running with a high enough priority?

I'm saying that the current scheduler adjusts for interactive loads,
this new one doesn't.  I'm seeing interactivity regressions, and they
are not fixed with nice unless nice is used to maximum effect.  I'm
saying yes, I can lower my expectations, but no I don't want to.

A four line summary is as short as I can make it.

	-Mike

