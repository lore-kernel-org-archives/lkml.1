Return-Path: <linux-kernel-owner+w=401wt.eu-S965770AbXCFCXN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965770AbXCFCXN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 21:23:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965771AbXCFCXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 21:23:13 -0500
Received: from smtp.osdl.org ([65.172.181.24]:47471 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965770AbXCFCXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 21:23:11 -0500
Date: Mon, 5 Mar 2007 18:18:22 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
cc: Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Emil Karlson <jkarlson@cc.hut.fi>,
       "Michael S. Tsirkin" <mst@mellanox.co.il>, Ingo Molnar <mingo@elte.hu>,
       Soeren Sonnenburg <kernel@nn7.de>, Len Brown <lenb@kernel.org>
Subject: Re: [5/6] 2.6.21-rc2: known regressions
In-Reply-To: <Pine.LNX.4.64.0703051730230.3998@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0703051810030.3998@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org> 
 <20070305015040.GJ3441@stusta.de>  <1173138193.24738.236.camel@localhost.localdomain>
  <Pine.LNX.4.64.0703051542030.3998@woody.linux-foundation.org> 
 <Pine.LNX.4.64.0703051626490.3998@woody.linux-foundation.org>
 <1173142948.24738.257.camel@localhost.localdomain>
 <Pine.LNX.4.64.0703051730230.3998@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 5 Mar 2007, Linus Torvalds wrote:
> 
> Compiling right now - delayed because I just had to pick up one of the 
> kids from gymnastics.

Ok, it does indeed solve the problem for me.

Mind sending a signed-off thing with explanations etc?

		Linus
