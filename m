Return-Path: <linux-kernel-owner+w=401wt.eu-S1762319AbYBWKEJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762319AbYBWKEJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 05:04:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754309AbYBWKD4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 05:03:56 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48288 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753594AbYBWKD4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 05:03:56 -0500
Date: Sat, 23 Feb 2008 11:03:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: introduce kernel/head32.c
Message-ID: <20080223100343.GB23833@elte.hu>
References: <20080223090534.GA12161@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080223090534.GA12161@uranus.ravnborg.org>
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


* Sam Ravnborg <sam@ravnborg.org> wrote:

> >From 7143f15993be4709e59c43fb65b086a8402e589b Mon Sep 17 00:00:00 2001
> From: ebiederm@xmission.com (Eric W. Biederman)
> Date: Sat, 23 Feb 2008 09:58:20 +0100
> Subject: [PATCH] x86: introduce kernel/head32.c
> 
> Copy x86_64 and add a head32.c so we can start moving early
> architecture initialization out of assembly.

thanks, applied.

	Ingo
