Return-Path: <linux-kernel-owner+w=401wt.eu-S1755885AbZASRLf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885AbZASRLf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 12:11:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755323AbZASRLX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 12:11:23 -0500
Received: from relay3.sgi.com ([192.48.171.31]:46515 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753022AbZASRLV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 12:11:21 -0500
Message-ID: <4974B437.6080004@sgi.com>
Date: Mon, 19 Jan 2009 09:11:19 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Ingo Molnar <mingo@redhat.com>, Dave Jones <davej@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>, cpufreq@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] cpu freq: fix problems with work_on_cpu usage in
 acpi-cpufreq [PULL request]
References: <20090116191108.135927000@polaris-admin.engr.sgi.com> <49711A64.3050103@sgi.com> <20090117220858.GA12374@elte.hu>
In-Reply-To: <20090117220858.GA12374@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Mike Travis <travis@sgi.com> wrote:
> 
>> Hi Ingo,
>>
>> If you are ready for these, I've pushed them to the cpus4096-for-ingo 
>> tree.  (Note it's been renamed.)
> 
> that might be fine for v2.6.30, but we need separate patches in a separate 
> branch, for all -git relevant fixes - in as safe way as possible.
> 
> 	Ingo

So you want me to create a separate branch for each patch?

And don't you think the fix to work_on_cpu should be put into 2.6.29?

Thanks,
Mike

