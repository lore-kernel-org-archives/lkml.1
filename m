Return-Path: <linux-kernel-owner+w=401wt.eu-S1757547AbYKIVtX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757547AbYKIVtX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 16:49:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758597AbYKIVqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 16:46:40 -0500
Received: from ozlabs.org ([203.10.76.45]:37041 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758584AbYKIVqj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 16:46:39 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] cpumask: introduce new API, without changing anything
Date: Mon, 10 Nov 2008 08:46:34 +1100
User-Agent: KMail/1.9.10
Cc: Ingo Molnar <mingo@elte.hu>, Stephen Rothwell <sfr@canb.auug.org.au>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Mike Travis <travis@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <20081029152849.3883d072.sfr@canb.auug.org.au> <200811082024.20157.rusty@rustcorp.com.au> <alpine.LFD.2.00.0811091200090.3468@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0811091200090.3468@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811100846.35404.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 November 2008 07:01:50 Linus Torvalds wrote:
> On Sat, 8 Nov 2008, Rusty Russell wrote:
> > Ok, I sent through the latest delta on top of this before, but see below.
>
> Can somebody send a final patch-set to me? Right now I have multiple
> versions of patches, apparently on top of each other, and sometimes
> multiple patches per email. Very confusing, and I do _not_ want to apply
> the wrong thing by mistake.

Sure, am waiting for a final run through linux-next.  There's no huge hurry 
and it helps find obscure arch compile/include issues.

Cheers,
Rusty.
