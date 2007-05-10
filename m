Return-Path: <linux-kernel-owner+w=401wt.eu-S1755980AbXEJBvv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755980AbXEJBvv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 21:51:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753089AbXEJBvl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 21:51:41 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49939 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752652AbXEJBvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 21:51:40 -0400
Date: Wed, 9 May 2007 18:51:25 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Neil Brown <neilb@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-raid@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Greaves <david@dgreaves.com>, Doug Ledford <dledford@redhat.com>
Subject: Re: Please revert 5b479c91da90eef605f851508744bfe8269591a0 (md
 partition rescan)
In-Reply-To: <17986.26930.952993.510918@notabene.brown>
Message-ID: <alpine.LFD.0.98.0705091848370.4062@woody.linux-foundation.org>
References: <17986.26930.952993.510918@notabene.brown>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 10 May 2007, Neil Brown wrote:
> 
> Hi Linus,
>  Could you please revert
> 
>     5b479c91da90eef605f851508744bfe8269591a0

Done.

(But Andrew never saw your email, I suspect: "akpm@suse.de" is probably 
some strange mixup of Andrew Morton and Andi Kleen in your mind ;)

		Linus
