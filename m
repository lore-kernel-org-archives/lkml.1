Return-Path: <linux-kernel-owner+w=401wt.eu-S1754755AbZLTPNK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755AbZLTPNK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 10:13:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753760AbZLTPNI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 10:13:08 -0500
Received: from mail.gmx.net ([213.165.64.20]:53864 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753654AbZLTPNH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 10:13:07 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX194cJFalG94CDIKsWaXvdz+IKe/c7/nX+hjoLldsK
	EuefWtJCkP5AzN
Subject: Re: x264 benchmarks BFS vs CFS
From: Mike Galbraith <efault@gmx.de>
To: Kasper Sandberg <lkml@metanurb.dk>
Cc: Andres Freund <andres@anarazel.de>, Con Kolivas <kernel@kolivas.org>,
       Jason Garrett-Glaser <darkshikari@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML Mailinglist <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <1261311050.14314.67.camel@localhost>
References: <1261042383.14314.0.camel@localhost>
	 <1261195412.8240.153.camel@marge.simson.net>
	 <1261244163.14314.62.camel@localhost>
	 <200912200422.18314.andres@anarazel.de>
	 <1261311050.14314.67.camel@localhost>
Content-Type: text/plain
Date: Sun, 20 Dec 2009 16:13:01 +0100
Message-Id: <1261321981.6105.60.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.67
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-12-20 at 13:10 +0100, Kasper Sandberg wrote:

> and as for CFS, it SHOULD exhibit fair behavior anyway, isnt it called
> "completely FAIR scheduler" ? or is that just the marketing name?

Clue:  CFS _did_ distribute CPU evenly.  Ponder that for a moment.

	-Mike

