Return-Path: <linux-kernel-owner+w=401wt.eu-S933390AbZJFWPG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933390AbZJFWPG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 18:15:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757908AbZJFWPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 18:15:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46941 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755400AbZJFWPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 18:15:04 -0400
Date: Tue, 6 Oct 2009 15:13:12 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Hans-Peter Jansen <hpj@urpla.net>
cc: Dirk Hohndel <hohndel@infradead.org>, Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.32-rc3
In-Reply-To: <4ACBB7D7.10207@urpla.net>
Message-ID: <alpine.LFD.2.01.0910061511170.3432@localhost.localdomain>
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain>  <alpine.LFD.2.00.0910052140100.309@localhost.localdomain>  <1254797502.14122.146.camel@dhohndel-mobl.amr.corp.intel.com>  <alpine.LFD.2.01.0910060705240.3432@localhost.localdomain> 
 <1254839931.24117.9.camel@dhohndel-mobl.amr.corp.intel.com>  <alpine.LFD.2.01.0910060808220.3432@localhost.localdomain> <1254843242.24117.23.camel@dhohndel-mobl.amr.corp.intel.com> <alpine.LFD.2.01.0910060842450.3432@localhost.localdomain>
 <4ACBB7D7.10207@urpla.net>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 6 Oct 2009, Hans-Peter Jansen wrote:
> 
> Let's change the focus - what does it cost you:

No. You don't understand the difference between doing things right, and 
doing them wrong. It's not about "what does it cost me". It's about doing 
a really stupid thing that doesn't even _solve_ the problem in a lot of 
real cases, and doing the _right_ thing that solves it for every case.

And the fact that people cannot see the difference between those two 
cases is sad.

And no, this is not about "developers" vs "users". Not at all. Everything 
that makes it wrong for developers makes it wrong for users too. 

		Linus
