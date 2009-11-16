Return-Path: <linux-kernel-owner+w=401wt.eu-S1754092AbZKPVC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092AbZKPVC5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 16:02:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754073AbZKPVC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 16:02:56 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42015 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754052AbZKPVC4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 16:02:56 -0500
Date: Mon, 16 Nov 2009 22:02:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 5/5] perf buildid-list: New plumbing command
Message-ID: <20091116210242.GB6984@elte.hu>
References: <1258396365-29217-1-git-send-email-acme@infradead.org>
 <1258396365-29217-2-git-send-email-acme@infradead.org>
 <1258396365-29217-3-git-send-email-acme@infradead.org>
 <1258396365-29217-4-git-send-email-acme@infradead.org>
 <1258396365-29217-5-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258396365-29217-5-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

> +++ b/tools/perf/command-list.txt
> @@ -4,6 +4,7 @@
>  #
>  perf-annotate			mainporcelain common
>  perf-bench			mainporcelain common
> +perf-build-list			mainporcelain common

s/build-list/buildid-list

	Ingo
