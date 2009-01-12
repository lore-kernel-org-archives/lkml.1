Return-Path: <linux-kernel-owner+w=401wt.eu-S1762696AbZALWte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762696AbZALWte (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 17:49:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754669AbZALWbT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 17:31:19 -0500
Received: from relay2.sgi.com ([192.48.179.30]:47463 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758586AbZALWbR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 17:31:17 -0500
Message-ID: <496BC4B1.1080002@sgi.com>
Date: Mon, 12 Jan 2009 14:31:13 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Ingo Molnar <mingo@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] irq: update all archs to use new irq_desc	cpumask_var_t's.
References: <20090112220519.566749000@polaris-admin.engr.sgi.com> <20090112222123.GB15294@elte.hu>
In-Reply-To: <20090112222123.GB15294@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Mike Travis <travis@sgi.com> wrote:
> 
>> Ingo - should I push these to tip/cpus4096 via the cpus4096-for-ingo 
>> tree since that has the relevant changes to irq_desc?  Or by some other 
>> means?
> 
> yes, please update cpus4096-for-ingo so that i can pull it from your tree.
> 
> 	Ingo

Ok, I will do that right now.  And then you'll pull and do these other things:

> this should all be a single patch, because the cpus4096 tree does not 
> build on these arhitectures right now.

> in fact, i think i'll rebase the whole lineup (so no need to resend - i'll 
> squash these fixes together), because this is how it looks like right now:

???

Thanks,
Mike
