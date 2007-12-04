Return-Path: <linux-kernel-owner+w=401wt.eu-S1753638AbXLDNRk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753638AbXLDNRk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 08:17:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752764AbXLDNRc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 08:17:32 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38722 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752753AbXLDNRb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 08:17:31 -0500
Date: Tue, 4 Dec 2007 14:17:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jie Chen <chen@jlab.org>
Cc: Simon Holm Th??gersen <odie@cs.aau.dk>, Eric Dumazet <dada1@cosmosbay.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Possible bug from kernel 2.6.22 and above, 2.6.24-rc4
Message-ID: <20071204131707.GA4232@elte.hu>
References: <4744966C.900@jlab.org> <4744ADA9.7040905@cosmosbay.com> <4744E0DC.7050808@jlab.org> <1195698770.11808.4.camel@odie.local> <4744F042.4070002@jlab.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4744F042.4070002@jlab.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0094]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jie Chen <chen@jlab.org> wrote:

> Simon Holm Th??gersen wrote:
>> ons, 21 11 2007 kl. 20:52 -0500, skrev Jie Chen:
>
>> There is a backport of the CFS scheduler to 2.6.21, see
>> http://lkml.org/lkml/2007/11/19/127
>>
> Hi, Simon:
>
> I will try that after the thanksgiving holiday to find out whether the 
> odd behavior will show up using 2.6.21 with back ported CFS.

would be also nice to test this with 2.6.24-rc4.

	Ingo
