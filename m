Return-Path: <linux-kernel-owner+w=401wt.eu-S1758716AbYHVGum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758716AbYHVGum (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 02:50:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753044AbYHVGue
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 02:50:34 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56290 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752414AbYHVGue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 02:50:34 -0400
Date: Fri, 22 Aug 2008 08:50:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>,
       linux-kernel@vger.kernel.org, mathieu.desnoyers@polymtl.ca
Subject: Re: 2.6.{26.2,27-rc} oops on virtualbox
Message-ID: <20080822065012.GV14110@elte.hu>
References: <20080820162925.75a5e064@doriath.conectiva> <48ADDF4F.2020401@zytor.com> <48AE5FCF.6030103@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48AE5FCF.6030103@zytor.com>
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


* H. Peter Anvin <hpa@zytor.com> wrote:

> H. Peter Anvin wrote:
>>>
>>>  Does this look like a kernel bug?
>>>
>>
>> No, it looks like a very common virtualizer bug.  Does the attached  
>> patch work for you?
>>
>
> Also, in addition to this, please try tip:master.  There is a patch in 
> tip:master which I hope should fix this problem, but the details are 
> important.

access coordinates would be at:

  http://people.redhat.com/mingo/tip.git/README

	Ingo
