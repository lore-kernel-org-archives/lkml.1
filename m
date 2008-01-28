Return-Path: <linux-kernel-owner+w=401wt.eu-S1760849AbYA1PC6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760849AbYA1PC6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 10:02:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753568AbYA1PCv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 10:02:51 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53113 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752831AbYA1PCu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 10:02:50 -0500
Date: Mon, 28 Jan 2008 16:02:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, apw@shadowen.org
Subject: Re: [PATCH 0/2] Relax restrictions on setting CONFIG_NUMA on x86
Message-ID: <20080128150233.GA12021@elte.hu>
References: <20080118153529.12646.5260.sendpatchset@skynet.skynet.ie> <20080121093702.8FC2.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20080123105810.F295.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20080123102332.GB21455@csn.ul.ie> <2f11576a0801260610m29f4e7ecle9828d8bbaa462cd@mail.gmail.com> <20080126171803.GA29252@csn.ul.ie> <2f11576a0801262254i55cb2c96q40023aa0e53bffce@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2f11576a0801262254i55cb2c96q40023aa0e53bffce@mail.gmail.com>
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


* KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> > Can you replace this patch with the patch below instead and try 
> > again please? This is the patch that is actually in git-x86. Out of 
> > curiousity, have you tried the latest mm branch from git-x86?
> 
> to be honest, I didn't understand usage of git, sorry. I learned 
> method of git checkout today and test again (head of git-x86 + your 
> previous patch).

here's a QuickStart:

   http://redhat.com/~mingo/x86.git/README

	Ingo
