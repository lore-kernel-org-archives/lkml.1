Return-Path: <linux-kernel-owner+w=401wt.eu-S1755196AbZESJie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196AbZESJie (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 05:38:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753633AbZESJi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 05:38:26 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40148 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753657AbZESJiZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 05:38:25 -0400
Date: Tue, 19 May 2009 11:37:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Jack Steiner <steiner@sgi.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: tip: patches in git for irq and numa
Message-ID: <20090519093754.GH31404@elte.hu>
References: <4A0A6700.3070100@kernel.org> <20090513133635.GB7384@elte.hu> <4A0AFA6E.5050200@kernel.org> <20090515173521.GA29647@elte.hu> <4A0DE0ED.6090402@kernel.org> <20090518072952.GA12460@elte.hu> <1242654650.26820.429.camel@twins> <4A1178D5.5050900@kernel.org> <1242659477.26820.433.camel@twins> <4A119990.9020606@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A119990.9020606@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Yinghai Lu <yinghai@kernel.org> wrote:

> please check following patch
> 
> Thanks

I've applied it to tip:irq/numa, thanks Yingai. Pushed it out into 
tip:master - Peter please check wether:

  3b44254: Merge branch 'irq/numa'

or later versions of -tip work fine on your Opteron box.

Thanks,

	Ingo
