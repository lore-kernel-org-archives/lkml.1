Return-Path: <linux-kernel-owner+w=401wt.eu-S1755947AbZDGJV7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755947AbZDGJV7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 05:21:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751653AbZDGJVs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 05:21:48 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55994 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751590AbZDGJVr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 05:21:47 -0400
Date: Tue, 7 Apr 2009 11:21:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/15] various perf counter bits
Message-ID: <20090407092141.GA19607@elte.hu>
References: <20090406094458.977814421@chello.nl> <20090407092108.GA17301@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090407092108.GA17301@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
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


we also still have this build warning when building kerneltop:

 kerneltop.c: In function ‘mmap_read’:
 kerneltop.c:1263: warning: comparison of distinct pointer types lacks a cast

	Ingo
