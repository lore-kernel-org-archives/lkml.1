Return-Path: <linux-kernel-owner+w=401wt.eu-S1755550AbYD2M30@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550AbYD2M30 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 08:29:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752884AbYD2M3S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 08:29:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36006 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752355AbYD2M3R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 08:29:17 -0400
Date: Tue, 29 Apr 2008 14:29:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frans Pop <elendil@planet.nl>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Mike Galbraith <efault@gmx.de>, Richard Jonsson <richie@coderworld.net>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [git pull] scheduler changes for v2.6.26
Message-ID: <20080429122903.GG31271@elte.hu>
References: <20080419181304.GB21353@elte.hu> <200804231136.50639.elendil@planet.nl> <20080423094644.GB23293@elte.hu> <200804231536.03076.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804231536.03076.elendil@planet.nl>
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


* Frans Pop <elendil@planet.nl> wrote:

> P.S. It would probably be good to just mention the units in the 
> headers of the debug files. It may be obvious to you, but that way 
> it's obvious even to morons like me :-P

yeah, agreed. We did that in -rt's /proc/latency_trace but it isnt there 
in ftrace. Steve?

	Ingo
