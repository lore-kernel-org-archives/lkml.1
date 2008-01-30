Return-Path: <linux-kernel-owner+w=401wt.eu-S1755460AbYA3QgA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460AbYA3QgA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 11:36:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761408AbYA3Qfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 11:35:34 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38124 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761396AbYA3Qfc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 11:35:32 -0500
Date: Wed, 30 Jan 2008 17:35:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>
Subject: Re: sleepy linux self-test
Message-ID: <20080130163511.GA30797@elte.hu>
References: <20080130131748.GA3796@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080130131748.GA3796@elf.ucw.cz>
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


* Pavel Machek <pavel@ucw.cz> wrote:

> Hi!
> 
> This version should work, at least it did not fail in my testing. It 
> does one test 5 second after bootup, then periodically once per 500 
> seconds. Different parameters are trivial to tweak.

nice - is nohz=off still needed? (if not, what was the problem with 
nohz?)

	Ingo
