Return-Path: <linux-kernel-owner+w=401wt.eu-S1759565AbYDNHOk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759565AbYDNHOk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 03:14:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754324AbYDNHOc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 03:14:32 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42760 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754231AbYDNHOc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 03:14:32 -0400
Date: Mon, 14 Apr 2008 09:14:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Bob Tracy <rct@frus.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [Bug #10366] 2.6.25-rc7: warn_on_slowpath triggered
Message-ID: <20080414071409.GC16163@elte.hu>
References: <RR4Oy_oXY2J.A.b0H.A3lAIB@albercik> <oq66hWjeF4N.A.Tm.13lAIB@albercik> <20080413194837.GA6518@atjola.homenet>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080413194837.GA6518@atjola.homenet>
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


* Björn Steinbrink <B.Steinbrink@gmx.de> wrote:

> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10366
> > Subject		: 2.6.25-rc7: warn_on_slowpath triggered
> > Submitter	: Bob Tracy <rct@frus.com>
> > Date		: 2008-03-29 17:29 (16 days old)
> > References	: http://lkml.org/lkml/2008/3/29/125
> > Handled-By	: Björn Steinbrink <B.Steinbrink@gmx.de>
> > Patch		: http://lkml.org/lkml/2008/3/30/245
> 
> Ingo, you have that patch in your tree, are you going to push that to 
> Linus any time soon (ie. before 2.6.25)?

well, it's the PCI code, which should go via Greg - but i can send it 
via x86.git as well. Have prepared it for later today.

	Ingo

