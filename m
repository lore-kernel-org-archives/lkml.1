Return-Path: <linux-kernel-owner+w=401wt.eu-S1754597AbZJEU6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597AbZJEU6r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 16:58:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753947AbZJEU6q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 16:58:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55228 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753042AbZJEU6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 16:58:45 -0400
Date: Mon, 5 Oct 2009 13:56:29 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: balbir@linux.vnet.ibm.com, Len Brown <lenb@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Shaohua Li <shaohua.li@intel.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: Re: [git pull request] ACPI Processor Aggregator Driver for
 2.6.32-rc1
In-Reply-To: <200910052159.24920.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.01.0910051354450.3432@localhost.localdomain>
References: <alpine.LFD.2.00.0910030145140.25240@localhost.localdomain> <20091005033256.GA26592@balbir.in.ibm.com> <200910052159.24920.rjw@sisk.pl>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 5 Oct 2009, Rafael J. Wysocki wrote:
> 
> This thing has already been merged, it appears: and it looks like a 
> total breakage of rules to me.

Well, Len pointed out to me that the NAK is kind of pointless, since it 
had no constructive alternatives to the issue. So he left it in as 
documentation, but until the scheduler people can actually _do_ something 
about the problem, their voice doesn't really matter, does it?

		Linus
