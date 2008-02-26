Return-Path: <linux-kernel-owner+w=401wt.eu-S1760901AbYBZH17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760901AbYBZH17 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 02:27:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755065AbYBZH1v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 02:27:51 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:60100 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754941AbYBZH1u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 02:27:50 -0500
Date: Tue, 26 Feb 2008 08:27:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Vegard Nossum <vegard.nossum@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: compile problem in current x86.git
Message-ID: <20080226072740.GE24820@elte.hu>
References: <47C315CC.5020001@goop.org> <19f34abd0802251237q2aa5db03s522c77340cdc96a@mail.gmail.com> <20080225204438.GA1213@elte.hu> <20080225205035.GA3435@elte.hu> <47C35AB5.1040407@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47C35AB5.1040407@goop.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Ingo Molnar wrote:
>> Jeremy, you might want to start tracking x86.git#testing:
>>
>>   http://people.redhat.com/mingo/x86.git/README
>>
>> if you want to follow the latest & greatest x86.git code.
>>   
>
> Right, will do.

generally it's as well tested on x86 as #mm (so you should not notice 
any difference while tracking it), but it also includes work in progress 
bits that might touch other subsystems as well.

	Ingo
