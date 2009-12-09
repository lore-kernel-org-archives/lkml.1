Return-Path: <linux-kernel-owner+w=401wt.eu-S1754230AbZLIJ7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230AbZLIJ7Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 04:59:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754567AbZLIJ7W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 04:59:22 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35654 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754401AbZLIJ7S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 04:59:18 -0500
Date: Wed, 9 Dec 2009 10:59:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Xiao Guangrong <ericxiao.gr@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>, T??r??k Edwin <edwintorok@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] perf/sched: fix for getting task's execution time
Message-ID: <20091209095908.GB15499@elte.hu>
References: <4B1B8E0E.3040007@cn.fujitsu.com>
 <1260097512.7818.341.camel@laptop>
 <1260097609.7818.349.camel@laptop>
 <4B1BE588.8020608@gmail.com>
 <4B1CACC4.3030709@cn.fujitsu.com>
 <20091207073043.GH10868@elte.hu>
 <4B1F7322.80103@cn.fujitsu.com>
 <4B1F73E1.6040000@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B1F73E1.6040000@cn.fujitsu.com>
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


* Xiao Guangrong <xiaoguangrong@cn.fujitsu.com> wrote:

> Sorry, miss Reported-by, please ignore this mail, i'll resend it

I've added Edwin's Reported-by, no need to resend.

	Ingo
