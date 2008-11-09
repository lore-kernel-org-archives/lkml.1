Return-Path: <linux-kernel-owner+w=401wt.eu-S1758823AbYKIUIy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758823AbYKIUIy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 15:08:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757059AbYKIUCb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 15:02:31 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37996 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756089AbYKIUC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 15:02:29 -0500
Date: Sun, 9 Nov 2008 12:01:50 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Ingo Molnar <mingo@elte.hu>, Stephen Rothwell <sfr@canb.auug.org.au>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Mike Travis <travis@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpumask: introduce new API, without changing anything
In-Reply-To: <200811082024.20157.rusty@rustcorp.com.au>
Message-ID: <alpine.LFD.2.00.0811091200090.3468@nehalem.linux-foundation.org>
References: <20081029152849.3883d072.sfr@canb.auug.org.au> <20081107093911.GD7787@elte.hu> <20081107122400.GA20777@elte.hu> <200811082024.20157.rusty@rustcorp.com.au>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 8 Nov 2008, Rusty Russell wrote:
> 
> Ok, I sent through the latest delta on top of this before, but see below.

Can somebody send a final patch-set to me? Right now I have multiple 
versions of patches, apparently on top of each other, and sometimes 
multiple patches per email. Very confusing, and I do _not_ want to apply 
the wrong thing by mistake.

		Linus
