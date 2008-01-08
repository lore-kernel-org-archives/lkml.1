Return-Path: <linux-kernel-owner+w=401wt.eu-S1754204AbYAHKYo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204AbYAHKYo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 05:24:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753980AbYAHKYd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 05:24:33 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:57904 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751144AbYAHKYc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 05:24:32 -0500
Date: Tue, 8 Jan 2008 11:24:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Miles Lane <miles.lane@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: 2.6.24-rc7 -- WARNING: at kernel/lockdep.c:2662 check_flags()
Message-ID: <20080108102421.GA9732@elte.hu>
References: <a44ae5cd0801061934w782e320ew5e5e93280ded95ee@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a44ae5cd0801061934w782e320ew5e5e93280ded95ee@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0056]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Miles Lane <miles.lane@gmail.com> wrote:

> Is this an issue in the Totem code or in the kernel? Please, let me 
> know if you need my .config file.

could you try Peter's patch from:

http://groups.google.com/group/linux.kernel/browse_thread/thread/d4cdeeedd72719ed

does it fix that warning?

	Ingo
