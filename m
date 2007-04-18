Return-Path: <linux-kernel-owner+w=401wt.eu-S2992738AbXDRVNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992738AbXDRVNV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 17:13:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992744AbXDRVNV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 17:13:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58205 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992738AbXDRVNU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 17:13:20 -0400
Date: Wed, 18 Apr 2007 23:12:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: =?utf-8?B?Uy7Dh2HEn2xhcg==?= Onur <caglar@pardus.org.tr>
Cc: Christoph Pfister <christophpfister@gmail.com>,
       linux-kernel@vger.kernel.org, Michael Lothian <mike@fireburn.co.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Christophe Thommeret <hftom@free.fr>, Jurgen Kofler <kaffeine@gmx.net>,
       Ulrich Drepper <drepper@redhat.com>
Subject: Re: Kaffeine problem with CFS
Message-ID: <20070418211257.GA7427@elte.hu>
References: <19a3b7a80704150955x4e1d809eh929b0f931f842a06@mail.gmail.com> <200704181625.51389.caglar@pardus.org.tr> <20070418154811.GA16842@elte.hu> <200704190008.19262.caglar@pardus.org.tr>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200704190008.19262.caglar@pardus.org.tr>
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


* S.Çağlar Onur <caglar@pardus.org.tr> wrote:

> > great! Could you please unapply the hack above and try the proper 
> > fix below, does this one solve the hangs too?
> 
> Instead of that one, i tried CFSv3 and i cannot reproduce the hang 
> anymore, Thanks!...

cool, thanks for the quick turnaround!

	Ingo
