Return-Path: <linux-kernel-owner+w=401wt.eu-S1757369AbZF3WIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757369AbZF3WIX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 18:08:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752670AbZF3WIQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 18:08:16 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51894 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752569AbZF3WIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 18:08:16 -0400
Date: Wed, 1 Jul 2009 00:08:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] perf_counter tools: filter by comm, dso & symbol
	lists Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-ID: <20090630220807.GD1241@elte.hu>
References: <1246399282-20934-1-git-send-email-acme@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246399282-20934-1-git-send-email-acme@redhat.com>
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


* Arnaldo Carvalho de Melo <acme@redhat.com> wrote:

> Hi,
> 
> 	The following patches allows filtering by comm, dso & 
> symbol lists, in a way similar to oprofile image: parameters.

Cool, thanks Arnaldo! Applied to tip:perfcounters/urgent.

	Ingo
