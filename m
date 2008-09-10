Return-Path: <linux-kernel-owner+w=401wt.eu-S1753790AbYIJIEx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753790AbYIJIEx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 04:04:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751501AbYIJIEj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 04:04:39 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53320 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751453AbYIJIEi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 04:04:38 -0400
Date: Wed, 10 Sep 2008 10:04:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: "Yang, Sheng" <sheng.yang@intel.com>, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@qumranet.com>, Andi Kleen <ak@linux.intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/2] x86: Extended cpuinfo to show virtualization HW
	features
Message-ID: <20080910080421.GC15255@elte.hu>
References: <12209432941440-git-send-email-sheng.yang@intel.com> <1220943294312-git-send-email-sheng.yang@intel.com> <86802c440809090052t2e626ce8h4fda865b8cbce00b@mail.gmail.com> <200809091605.42121.sheng.yang@intel.com> <86802c440809091045h2d4f1776g94355e1b1dd1b29e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440809091045h2d4f1776g94355e1b1dd1b29e@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> On Tue, Sep 9, 2008 at 1:05 AM, Yang, Sheng <sheng.yang@intel.com> wrote:
> >
> > Yeah, I've considered that, but seems duplicate for both files? The feature
> > detection code is the same. Any way to merge them?
> 
> just merged intel_64.c into intel.c...

it's all in tip/master:

  http://people.redhat.com/mingo/tip.git/README

would it be possible to get a patchset ontop of that?

	Ingo
