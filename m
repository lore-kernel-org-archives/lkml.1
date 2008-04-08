Return-Path: <linux-kernel-owner+w=401wt.eu-S1758396AbYDHPKZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758396AbYDHPKZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 11:10:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752658AbYDHPKN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 11:10:13 -0400
Received: from relay2.sgi.com ([192.48.171.30]:41417 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752648AbYDHPKM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 11:10:12 -0400
Message-ID: <47FB8AD2.2040201@sgi.com>
Date: Tue, 08 Apr 2008 08:10:10 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Alexander van Heukelum <heukelum@mailshack.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       heukelum@fastmail.fm
Subject: Re: [PATCH 1/2] boot: increase stack size for kernel boot loader
 decompressor
References: <20080405013014.478571000@polaris-admin.engr.sgi.com> <20080405013014.693571000@polaris-admin.engr.sgi.com> <20080405134626.GA15894@mailshack.com> <47FA6478.1070301@sgi.com> <20080407214434.GA5296@mailshack.com> <20080408122007.GA11832@mailshack.com> <20080408134112.GA4277@elte.hu>
In-Reply-To: <20080408134112.GA4277@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Alexander van Heukelum <heukelum@mailshack.com> wrote:
> 
>> Hi Ingo,
>>
>> I see you have applied the following patch to x86#for-akpm. It was 
>> really ment for testing only. I think you ment to use this one 
>> instead?
> 
> yep, i wanted to see how it holds up in testing - it's OK so far. I've 
> got your other, fuller one queued up meanwhile - it's not pushed out 
> yet.
> 
> 	Ingo

I will try it out on my failing case as soon as I can...

Thanks,
Mike
