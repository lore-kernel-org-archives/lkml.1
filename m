Return-Path: <linux-kernel-owner+w=401wt.eu-S1753930AbZJLGgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930AbZJLGgc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 02:36:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752782AbZJLGgb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 02:36:31 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55264 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752753AbZJLGga (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 02:36:30 -0400
Date: Mon, 12 Oct 2009 08:35:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [patch] perf build questions
Message-ID: <20091012063547.GB14377@elte.hu>
References: <20091005131729.78444bfb.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091005131729.78444bfb.randy.dunlap@oracle.com>
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


* Randy Dunlap <randy.dunlap@oracle.com> wrote:

> Also, I see build errors/warnings (-Werror).  Others aren't seeing these?
> Just due to my gcc version?

Thanks for the fix. Which GCC version is this btw?

	Ingo
