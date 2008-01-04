Return-Path: <linux-kernel-owner+w=401wt.eu-S1758849AbYADJXm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758849AbYADJXm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 04:23:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754054AbYADJXf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 04:23:35 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50972 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754603AbYADJXe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 04:23:34 -0500
Date: Fri, 4 Jan 2008 10:23:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andi Kleen <ak@suse.de>, pavel@suse.cz, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH x86] [15/16] Force __cpuinit on for CONFIG_PM without
	HOTPLUG_CPU
Message-ID: <20080104092315.GL28740@elte.hu>
References: <20080103442.621670000@suse.de> <200801031822.02668.rjw@sisk.pl> <200801031842.49668.ak@suse.de> <200801032241.29218.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801032241.29218.rjw@sisk.pl>
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

> > So you would need to fix that first. Would be fine for me, but is 
> > out of scope for my patch.
> 
> OK, I'll fix that up later.

i'll apply Andi's patch to x86.git - or would like to maintain that 
patch?

	Ingo
