Return-Path: <linux-kernel-owner+w=401wt.eu-S1753444AbYGYPIP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444AbYGYPIP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 11:08:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751198AbYGYPH7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 11:07:59 -0400
Received: from gate.crashing.org ([63.228.1.57]:45850 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751319AbYGYPH7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 11:07:59 -0400
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       akpm <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Message-Id: <BAF7B55C-75C2-4BCA-8686-34A843865C91@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: benh@kernel.crashing.org
In-Reply-To: <1216973590.11188.99.camel@pasglop>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: [git pull] Please pull from powerpc.git merge branch
Date: Fri, 25 Jul 2008 10:07:43 -0500
References: <1216973590.11188.99.camel@pasglop>
X-Mailer: Apple Mail (2.926)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 25, 2008, at 3:13 AM, Benjamin Herrenschmidt wrote:

>
> Benjamin Herrenschmidt (1):
>      Move update_mmu_cache() declaration from tlbflush.h to pgtable.h

I'm guessing this was pretty trivial, but please post patches to the  
list even if you've committed them to your tree.

- k
