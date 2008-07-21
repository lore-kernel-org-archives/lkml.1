Return-Path: <linux-kernel-owner+w=401wt.eu-S1752774AbYGURRX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774AbYGURRX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 13:17:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751345AbYGURRP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 13:17:15 -0400
Received: from relay1.sgi.com ([192.48.171.29]:36747 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751040AbYGURRO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 13:17:14 -0400
Message-ID: <4884C4A1.7010006@sgi.com>
Date: Mon, 21 Jul 2008 10:17:21 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] NR_CPUS: Various replacements for NR_CPUS
References: <20080719011126.745278000@polaris-admin.engr.sgi.com> <20080720082312.GA30150@elte.hu>
In-Reply-To: <20080720082312.GA30150@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Mike Travis <travis@sgi.com> wrote:
> 
>> I've found one old patch that seems to have been misplaced [...]
> 
> How did you notice that i missed them - actual crashes, or measurable 
> performance impact?

It might not have been you.  I was just doing a survey again of NR_CPUS
usages and noticed something that looked familiar.  (In fact there were
two patches missing but when I updated the source one of them *magically*
appeared... ;-)

I have three more cases that can be changed coming real soon now.

> 
>> [...] and a few minor new instances where usage of NR_CPUS may be 
>> incorrect.
>>
>> Also a fixup for CPUMASK_ALLOC is included.
> 
> applied to tip/cpus4096, thanks Mike.

No, no, thank you!  ;-)

Mike
