Return-Path: <linux-kernel-owner+w=401wt.eu-S932568AbYARW2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932568AbYARW2h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 17:28:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762534AbYARW22
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 17:28:28 -0500
Received: from mx1.redhat.com ([66.187.233.31]:40145 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755593AbYARW21 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 17:28:27 -0500
To: Arjan van de Ven <arjan@infradead.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 2/3] Latencytop instrumentations part 1
References: <4790E3A6.7060807@linux.intel.com>
	<20080118094048.10e79ff9@laptopd505.fenrus.org>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Fri, 18 Jan 2008 17:26:09 -0500
In-Reply-To: <20080118094048.10e79ff9@laptopd505.fenrus.org> (Arjan van de Ven's message of "Fri, 18 Jan 2008 09:40:48 -0800")
Message-ID: <y0mmyr2ydmm.fsf@ton.toronto.redhat.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven <arjan@infradead.org> writes:

> This patch contains the first set of instrumentations for latencytop;
> each instrumentation needs to be evaluated for usefulness before this
> can go into mainline; posting here just to show how the infrastructure
> can be used
> [...]

Can you suggest of some reason why all this instrumentation could
not be in the form of standard markers (perhaps conditionally
compiled out if necessary)?

- FChE
