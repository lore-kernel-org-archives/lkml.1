Return-Path: <linux-kernel-owner+w=401wt.eu-S1757496AbYJWNl6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757496AbYJWNl6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 09:41:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756425AbYJWNh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 09:37:58 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:33982 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756411AbYJWNh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 09:37:57 -0400
Message-ID: <49007E71.5010000@sgi.com>
Date: Thu, 23 Oct 2008 06:38:57 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/35] cpumask: Replace cpumask_t with struct cpumask
References: <20081023020826.051012000@polaris-admin.engr.sgi.com> <20081023120322.GC25132@elte.hu> <49007410.8090700@sgi.com> <20081023130111.GA20321@elte.hu>
In-Reply-To: <20081023130111.GA20321@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Mike Travis <travis@sgi.com> wrote:
> 
>>> I fixed the From: line oddities - please holler if they are wrong 
>>> anywhere, we can still rebase this.
>> I found two of them and had resubmitted them, but perhaps that didn't 
>> take either?
> 
> i had to fix up about 20.
> 
> 	Ingo

Ok, thanks.  I suspect quilt mail is handling things incorrectly (I am
using a slightly older version (0.46 vs. 0.47) [the later removed
"remove" which I found handier than "revert".]  I'll put checking this
out on my 'todo' list.

Thanks,
Mike

