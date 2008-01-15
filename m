Return-Path: <linux-kernel-owner+w=401wt.eu-S1755520AbYAONYu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520AbYAONYu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 08:24:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750914AbYAONYn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 08:24:43 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48851 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750791AbYAONYm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 08:24:42 -0500
Date: Tue, 15 Jan 2008 14:24:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
Cc: Jan Beulich <jbeulich@novell.com>, linux-kernel@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy@xensource.com>
Subject: Re: [PATCH] adjust/fix LDT handling for Xen
Message-ID: <20080115132423.GD7025@elte.hu>
References: <4787436E.76E4.0078.0@novell.com> <20080114154817.GA14000@elte.hu> <478B96A5.76E4.0078.0@novell.com> <478B9606.6020008@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <478B9606.6020008@citrix.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com> wrote:

>>> coul dyou try this against x86.git as well? We already unified ldt.c as 
>>> part of the paravirt patches.
>>>     
>>
>> Sure, but it may take me a little while.
>
> I've got the unified version here. 

thanks, applied.

> Acked-by: Jeremy Fitzhardinge <jeremy@xensource.com>

please use Signed-off-by when passing through (or modifying) patches.

	Ingo
