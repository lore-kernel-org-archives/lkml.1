Return-Path: <linux-kernel-owner+w=401wt.eu-S1755048AbZGMJBq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755048AbZGMJBq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 05:01:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754985AbZGMJBq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 05:01:46 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56081 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754982AbZGMJBp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 05:01:45 -0400
Date: Mon, 13 Jul 2009 11:01:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] ftrace: Add missing __init in ftrace_profile_debugfs()
Message-ID: <20090713090139.GD6757@elte.hu>
References: <b9df5fa10907120358t7101511cle30e025c3adcbe54@mail.gmail.com> <4A5A8430.7050300@cn.fujitsu.com> <b9df5fa10907122058s3edc4c81t670aed7b7160cf82@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b9df5fa10907122058s3edc4c81t670aed7b7160cf82@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rakib Mullick <rakib.mullick@gmail.com> wrote:

> On Mon, Jul 13, 2009 at 6:47 AM, Li Zefan<lizf@cn.fujitsu.com> wrote:
> 
> > Thanks. It has been fixed by commit
> > 9d9949ce45b42be7a8157ea00fff2b1005ed844a in tip tree
> >
> Ah, sorry for noice.

that commit was queued up for .32 - i've cherry-picked it over into 
the .31 queue of commits.

	Ingo
