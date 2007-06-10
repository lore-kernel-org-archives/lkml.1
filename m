Return-Path: <linux-kernel-owner+w=401wt.eu-S1762370AbXFJSIA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762370AbXFJSIA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 14:08:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755714AbXFJSHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 14:07:52 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45586 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755083AbXFJSHv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 14:07:51 -0400
Date: Sun, 10 Jun 2007 20:07:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mark Knecht <markknecht@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Lee Revell <rlrevell@gmail.com>
Subject: Re: 2.6.21-rt9 - IRQ23 consuming a steady 2.7% of CPU
Message-ID: <20070610180745.GA14912@elte.hu>
References: <5bdc1c8b0706100946k3acd6374uac8248e78f97433d@mail.gmail.com> <20070610172452.GA7560@elte.hu> <5bdc1c8b0706101038q2f0e3418t1a595e749b5bfe71@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5bdc1c8b0706101038q2f0e3418t1a595e749b5bfe71@mail.gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Mark Knecht <markknecht@gmail.com> wrote:

>   GMail is being kranky. Can you please send the patch as a zipped 
>   attachment?

you can pick it up from:

   http://people.redhat.com/mingo/realtime-preempt/testing/forcedeth-rt-tweak.patch

	Ingo
