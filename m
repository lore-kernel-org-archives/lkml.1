Return-Path: <linux-kernel-owner+w=401wt.eu-S932514AbXCZFqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932514AbXCZFqw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 01:46:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932562AbXCZFqw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 01:46:52 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53077 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932514AbXCZFqv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 01:46:51 -0400
Date: Mon, 26 Mar 2007 07:46:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Con Kolivas <kernel@kolivas.org>
Cc: linux list <linux-kernel@vger.kernel.org>, ck list <ck@vds.kolivas.org>,
       Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: rSDl cpu scheduler version 0.34-test patch
Message-ID: <20070326054631.GA7759@elte.hu>
References: <200703261100.22467.kernel@kolivas.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703261100.22467.kernel@kolivas.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Con Kolivas <kernel@kolivas.org> wrote:

> The patches available also include a rollup of sched: accurate user 
> accounting as this code touches the same area and it is most 
> convenient to include them together.

as i mentioned it before, please keep this one separate, as we want to 
apply it first.

	Ingo
