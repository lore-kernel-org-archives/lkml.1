Return-Path: <linux-kernel-owner+w=401wt.eu-S1754868AbYIERNg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868AbYIERNg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 13:13:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751270AbYIERNZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 13:13:25 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34403 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751824AbYIERNZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 13:13:25 -0400
Date: Fri, 5 Sep 2008 19:13:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?B?VPZy9ms=?= Edwin <edwintorok@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Please #include <limits.h> in hackbench.c
Message-ID: <20080905171307.GB27395@elte.hu>
References: <48BD1779.5030807@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <48BD1779.5030807@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.3
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.3555]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Török Edwin <edwintorok@gmail.com> wrote:

> Hi Ingo,
> 
> On Fedora Core 9 hackbench.c fails to compile because PTHREAD_STACK_MIN
> is not defined, adding
> a #include <limits.h> fixes it and makes it compile.
> 
> Please add #include<limits.h>

done, thx.

	Ingo
