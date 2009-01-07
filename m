Return-Path: <linux-kernel-owner+w=401wt.eu-S1761775AbZAGVVQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761775AbZAGVVQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 16:21:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752029AbZAGVVA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 16:21:00 -0500
Received: from relay2.sgi.com ([192.48.179.30]:44812 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756748AbZAGVVA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 16:21:00 -0500
Message-ID: <49651CB8.9060900@sgi.com>
Date: Wed, 07 Jan 2009 13:20:56 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Ingo Molnar <mingo@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] cpumask: more cpumask updates
References: <20090107195832.265117000@polaris-admin.engr.sgi.com> <20090107205229.GB4597@elte.hu>
In-Reply-To: <20090107205229.GB4597@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Mike Travis <travis@sgi.com> wrote:
> 
>> One big change to irq_desc and a few smaller maintenance type updates.
>>
>> 	cpumask: update irq_desc to use cpumask_var_t
>> 	cpumask: Use topology_core_cpumask()/topology_thread_cpumask()
>> 	cpumask: convert misc driver functions
>> 	cpumask: convert drivers/net/sfc
>> 	cpumask: convert other misc kernel functions
>>
>> Based on tip/cpus4096: v2.6.28-5703-g1d1a70e
>>
>> (Ingo - I added a blank line before the From: part and that seems to
>> separate it from the Subject.  Hopefully your git-am will still
>> recognizes it - I did try a git-am here and it seemed to work ok.)
>>
>> Signed-off-by: Mike Travis <travis@sgi.com>
> 
> Since you have it in a Git tree, why dont you send me a pull request?
> 
> I might be more picky about pull requests in general (because it's harder 
> to fix up a pulled tree than to fix up commits that come from emails - and 
> it's also more work for you if i refuse to pull than if i have some 
> comments over email-patches), but it's a much better (more scalable) 
> workflow in the long run than the email path.
> 
> 	Ingo

Ok, will do.

Thanks,
Mike
