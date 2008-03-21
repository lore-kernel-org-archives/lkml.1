Return-Path: <linux-kernel-owner+w=401wt.eu-S1755714AbYCUKyv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755714AbYCUKyv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 06:54:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753700AbYCUKyn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 06:54:43 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37710 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753630AbYCUKym (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 06:54:42 -0400
Date: Fri, 21 Mar 2008 11:54:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/12] mm/x86: bootmem
Message-ID: <20080321105427.GU20420@elte.hu>
References: <200803181256.23252.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803181256.23252.yhlu.kernel@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.1498]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> resending some patches about bootmem
> 
> some already in mm or x86
> 
> please keep the apply sequence.

it appears to me that we want most of these fixes in 2.6.25 - but they 
look rather intrusive and affect all architectures. Andrew, what do you 
think?

	Ingo
