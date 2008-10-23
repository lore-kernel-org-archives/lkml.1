Return-Path: <linux-kernel-owner+w=401wt.eu-S1756574AbYJWM4f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756574AbYJWM4f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 08:56:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753935AbYJWM4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 08:56:10 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:59917 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753874AbYJWM4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 08:56:09 -0400
Message-ID: <490074A5.4070406@sgi.com>
Date: Thu, 23 Oct 2008 05:57:09 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 22/35] cpumask: deprecate any_online_cpu() in favour of
 cpumask_any/cpumask_any_and From: Rusty Russell	<rusty@rustcorp.com.au>
References: <20081023020826.051012000@polaris-admin.engr.sgi.com> <20081023020830.685972000@polaris-admin.engr.sgi.com> <20081023102523.GA2351@elte.hu>
In-Reply-To: <20081023102523.GA2351@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Mike Travis <travis@sgi.com> wrote:
> 
>> any_online_cpu() is a good name, but it takes a cpumask_t, not a
>> pointer.
>>
>> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
>> Signed-off-by: Mike Travis <travis@sgi.com>
> 
> almost all the patches have a missing \n and thus wrong authorship...
> 
> 	Ingo

Hmm, that's strange.  It might be the way quilt mail gathers everything up
into mbox format.  I'll experiment a little bit to see what's causing it.
(This is the first time I've used the From: line as well as subject lines
w/o Subject: preceeding them.)

Thanks,
Mike
