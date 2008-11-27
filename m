Return-Path: <linux-kernel-owner+w=401wt.eu-S1754273AbYK0NX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754273AbYK0NX3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 08:23:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751862AbYK0NXU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 08:23:20 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:42609 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbYK0NXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 08:23:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=saUHxtn4Tyt102KCNYY+DbYEPoTz1g4RhXX1BCVmw+A3LU4lHO8a4Z5C0pEsrSzifO
         UZYFDOn3AgpTovKPiTuMzDWQvxaKWnu8OQVdMBcWcW1HtUnQ0u10ZFjydyuCoNi0WxId
         7vYOlVOlHPXojvwQdDZ2E5ahP0R1dbEMU4Ta0=
Message-ID: <492E9F42.6010808@gmail.com>
Date: Thu, 27 Nov 2008 15:23:14 +0200
From: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.17 (X11/20081018)
MIME-Version: 1.0
To: Nick Piggin <npiggin@suse.de>
CC: Mike Waychison <mikew@google.com>, Ying Han <yinghan@google.com>,
       Ingo Molnar <mingo@elte.hu>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, akpm <akpm@linux-foundation.org>,
       David Rientjes <rientjes@google.com>, Rohit Seth <rohitseth@google.com>,
       Hugh Dickins <hugh@veritas.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC v1][PATCH]page_fault retry with NOPAGE_RETRY
References: <492DAA24.8040100@google.com> <20081127085554.GD28285@wotan.suse.de> <492E6849.6090205@google.com> <492E8708.4060601@gmail.com> <20081127120330.GM28285@wotan.suse.de> <492E90BC.1090208@gmail.com> <20081127123926.GN28285@wotan.suse.de> <492E97FA.5000804@gmail.com> <20081127130525.GO28285@wotan.suse.de> <492E9C3C.9050507@gmail.com> <20081127131215.GQ28285@wotan.suse.de>
In-Reply-To: <20081127131215.GQ28285@wotan.suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008-11-27 15:12, Nick Piggin wrote:
> On Thu, Nov 27, 2008 at 03:10:20PM +0200, Török Edwin wrote:
>   
>>
>> Ok. Sorry for hijacking the thread, my testcase is not a good testcase
>> for what this patch tries to solve.
>>     
>
> No not at all. It's always really useful to hear any problems like this.
> I'd like you to keep participating... for one thing I'd like you to test
> my mmap_sem patch ;) (when I finish it)

Sure, just send me your patch when it is ready (together, or
before/after the rwsems patch).

Best regards,
--Edwin
