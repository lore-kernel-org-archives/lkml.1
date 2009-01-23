Return-Path: <linux-kernel-owner+w=401wt.eu-S1760626AbZAWFYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760626AbZAWFYn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 00:24:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750841AbZAWFYf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 00:24:35 -0500
Received: from hera.kernel.org ([140.211.167.34]:43820 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750823AbZAWFYe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 00:24:34 -0500
Message-ID: <4979548A.7050907@kernel.org>
Date: Fri, 23 Jan 2009 14:24:26 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Fwd: kernel panic when using disable_mtrr_trim [was: Re: memory
 	beyond4GB invisible to the system even though CONFIG_HIGHMEM64G=y]]
References: <49763718.7010501@kernel.org>	 <86802c440901201249v3c877a88ie8e5f3bbf6abb871@mail.gmail.com>	 <49794422.2080109@kernel.org> <86802c440901222119h3462cd10s75ad4e630defc4e@mail.gmail.com>
In-Reply-To: <86802c440901222119h3462cd10s75ad4e630defc4e@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 23 Jan 2009 05:24:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
>> Can you please try the current core/percpu branch?  I tried your
>> config but the problem doesn't happen here.
>>
> 
> the core/percpu is not merged into tip/master?

Yes, it is.  I just want to make sure we're looking at the same tree.
Anyways, do you still see this on the current master or core/percpu?

-- 
tejun
