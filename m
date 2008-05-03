Return-Path: <linux-kernel-owner+w=401wt.eu-S933065AbYECSGq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933065AbYECSGq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 14:06:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760238AbYECSGh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 14:06:37 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43198 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759446AbYECSGg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 14:06:36 -0400
Date: Sat, 3 May 2008 20:06:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Sam Ravnborg <sam@ravnborg.org>, Roland McGrath <roland@redhat.com>,
       Pavel Machek <pavel@suse.cz>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] fix rebuild of wakeup.bin
Message-ID: <20080503180612.GD5292@elte.hu>
References: <20080501010516.DD2FE26FA05@magilla.localdomain> <20080501093107.GA2392@uranus.ravnborg.org> <200805011248.53295.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805011248.53295.rjw@sisk.pl>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> > Add wakeup.lds to list af targets to avoid rebuilding wakeup.bin - 
> > from Roland McGrath.
> 
> Thanks for fixing this!
> 
> Ingo, please merge.

applied - thanks all!

	Ingo
