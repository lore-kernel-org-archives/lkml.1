Return-Path: <linux-kernel-owner+w=401wt.eu-S1761344AbYBLHkL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761344AbYBLHkL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 02:40:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759772AbYBLHj6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 02:39:58 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58007 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759626AbYBLHj5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 02:39:57 -0500
Date: Tue, 12 Feb 2008 08:39:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.25-rc1, weird build error
Message-ID: <20080212073926.GB11775@elte.hu>
References: <20080212070448.GA20033@elte.hu> <20080212071229.6FD95270192@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080212071229.6FD95270192@magilla.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0080]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Roland McGrath <roland@redhat.com> wrote:

> >   LD      init/built-in.o
> > distcc[12023] ERROR: compile (null) on localhost failed
> > make: *** [vmlinux.o] Error 1
> 
> That message sure looks to me like it could only be a distcc bug.

ok - but it never occured before.

	Ingo
