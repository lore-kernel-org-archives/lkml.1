Return-Path: <linux-kernel-owner+w=401wt.eu-S933861AbZHEJIG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933861AbZHEJIG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 05:08:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933794AbZHEJIF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 05:08:05 -0400
Received: from mga09.intel.com ([134.134.136.24]:25989 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933667AbZHEJID (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 05:08:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,327,1246863600"; 
   d="scan'208";a="436292386"
Message-ID: <4A794BF1.3060809@intel.com>
Date: Wed, 05 Aug 2009 17:08:01 +0800
From: "Zhai, Edwin" <edwin.zhai@intel.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: "Langsdorf, Mark" <mark.langsdorf@amd.com>
CC: Sheng Yang <sheng@linux.intel.com>, "Roedel, Joerg" <Joerg.Roedel@amd.com>,
       "peterz@infradead.org" <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, "avi@redhat.com" <avi@redhat.com>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Zhai, Edwin" <edwin.zhai@intel.com>
Subject: Re: [PATCH][KVM][retry 4] Add support for Pause Filtering to AMD
 SVM
References: <200905050909.58583.mark.langsdorf@amd.com>	<200907081319.57307.sheng@linux.intel.com>	<6453C3CB8E2B3646B0D020C112613273036209F0@sausexmb4.amd.com>	<200907090950.06204.sheng@linux.intel.com> <6453C3CB8E2B3646B0D020C112613273036209FB@sausexmb4.amd.com>
In-Reply-To: <6453C3CB8E2B3646B0D020C112613273036209FB@sausexmb4.amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark,
Do you have time to push the Linux scheduler changes for Pause Filtering 
now?  It's almost done after your work. If needing any help, pls. let me 
know.

Thanks,
edwin

Langsdorf, Mark wrote:
>> Um, I am afraid we have the different result... With your 
>> scheduler patch, we got 1% more performance improvement
>> in the quick test. Of course more tests are needed to
>> find a better value of delay.
>>     
>
> What was your test case?  How many runs did you do?
> My results had a lot of variance in them.
>
>   
>> Do you have time to work on it recently?
>>     
>
> I've been working with the former VI guys on some scheduler
> improvements for Xen, and hope to get back to this some
> next week.
>
> -Mark Langsdorf
> Operating System Research Center
> AMD
>
>   
