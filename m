Return-Path: <linux-kernel-owner+w=401wt.eu-S1762929AbXGJCa6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762929AbXGJCa6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 22:30:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762763AbXGJC2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 22:28:31 -0400
Received: from sccrmhc11.comcast.net ([63.240.77.81]:41695 "EHLO
	sccrmhc11.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762747AbXGJC23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 22:28:29 -0400
From: Jeremy Maitin-Shepard <jbms@cmu.edu>
To: Al Boldi <a1426z@gawab.com>
Cc: Pavel Machek <pavel@ucw.cz>, Nick Piggin <nickpiggin@yahoo.com.au>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Hibernation Redesign
References: <200707081737.21932.a1426z@gawab.com>
	<4691BC0F.8050909@yahoo.com.au> <20070709135205.GB3216@elf.ucw.cz>
	<200707091830.48074.a1426z@gawab.com>
X-Habeas-SWE-9: mark in spam to <http://www.habeas.com/report/>.
X-Habeas-SWE-8: Message (HCM) and not spam. Please report use of this
X-Habeas-SWE-7: warrant mark warrants that this is a Habeas Compliant
X-Habeas-SWE-6: email in exchange for a license for this Habeas
X-Habeas-SWE-5: Sender Warranted Email (SWE) (tm). The sender of this
X-Habeas-SWE-4: Copyright 2002 Habeas (tm)
X-Habeas-SWE-3: like Habeas SWE (tm)
X-Habeas-SWE-2: brightly anticipated
X-Habeas-SWE-1: winter into spring
Date: Mon, 09 Jul 2007 22:28:27 -0400
In-Reply-To: <200707091830.48074.a1426z@gawab.com> (Al Boldi's message of
	"Mon\, 9 Jul 2007 18\:30\:48 +0300")
Message-ID: <87hcoduh4k.fsf@jbms.ath.cx>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Boldi <a1426z@gawab.com> writes:

[snip]

> Who said we need two kernels?  You could inline it like Xen, which would give 
> you one kernel with two modes:  normal and hibernate.

I don't know a whole lot about xen, but it seems that one issue with
this approach is that it requires you run your system under a hypervisor
at all times, which may introduce some overhead.

-- 
Jeremy Maitin-Shepard
