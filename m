Return-Path: <linux-kernel-owner+w=401wt.eu-S1757465AbYEPMHU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757465AbYEPMHU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 08:07:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755016AbYEPMHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 08:07:04 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60214 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754418AbYEPMHD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 08:07:03 -0400
Date: Fri, 16 May 2008 14:06:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, pq@iki.fi, proski@gnu.org,
       sandmann@redhat.com, a.p.zijlstra@chello.nl, linuxppc-dev@ozlabs.org,
       paulus@samba.org, benh@kernel.crashing.org,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 2/2] ftrace: support for PowerPC
Message-ID: <20080516120620.GD11718@elte.hu>
References: <20080515034942.109223655@goodmis.org> <20080515035918.896765954@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080515035918.896765954@goodmis.org>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> This patch adds full support for ftrace for PowerPC (both 64 and 32 
> bit). This includes dynamic tracing and function filtering.

applied, thanks. Nice stuff! :)

	Ingo
