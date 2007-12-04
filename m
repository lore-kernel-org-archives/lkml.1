Return-Path: <linux-kernel-owner+w=401wt.eu-S1755939AbXLDV1i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939AbXLDV1i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 16:27:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752707AbXLDV10
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 16:27:26 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39950 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752683AbXLDV1Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 16:27:25 -0500
Date: Tue, 4 Dec 2007 22:27:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Gregory Haskins <ghaskins@novell.com>
Cc: rostedt@goodmis.org, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/23] RT balance v7
Message-ID: <20071204212705.GA10360@elte.hu>
References: <20071204204236.3567.65491.stgit@novell1.haskins.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071204204236.3567.65491.stgit@novell1.haskins.net>
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


* Gregory Haskins <ghaskins@novell.com> wrote:

> Ingo,
> 
> This series applies on GIT commit 
> 2254c2e0184c603f92fc9b81016ff4bb53da622d (2.6.24-rc4 (ish) git HEAD)

please post patches against sched-devel.git - it has part of your 
previous patches included already, plus some cleanups i did to them, so 
this series of yours wont apply. sched-devel.git is at:

 git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched-devel.git

	Ingo
