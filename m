Return-Path: <linux-kernel-owner+w=401wt.eu-S1752562AbZHZRzI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562AbZHZRzI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 13:55:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752421AbZHZRzH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 13:55:07 -0400
Received: from mx1-old.redhat.com ([66.187.233.31]:57190 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751522AbZHZRzG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 13:55:06 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
X-Fcc: ~/Mail/linus
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
       Helge Deller <deller@gmx.de>,
       "linux-parisc" <linux-parisc@vger.kernel.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>
Subject: Re: kernel segv with 2.6.31-rc6 ?
In-Reply-To: Rusty Russell's message of  Wednesday, 26 August 2009 21:50:34 +0930 <200908262150.34616.rusty@rustcorp.com.au>
References: <4A89CC4D.5040801@gmx.de>
	<200908251729.32855.rusty@rustcorp.com.au>
	<20090825192432.4D9CC411E3@magilla.sf.frob.com>
	<200908262150.34616.rusty@rustcorp.com.au>
X-Windows: never had it, never will.
Message-Id: <20090826175456.F17784050F@magilla.sf.frob.com>
Date: Wed, 26 Aug 2009 10:54:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> But at some level the problems accumulate until you go "nice idea, let's go
> do something else" :)

Yeah, done been gone.

> But don't let me discourage you!

I've already spent too much time making ET_REL .ko DWARF parsing work to be
very motivated to do things right so all that work would never have been
necessary like I've been grumbling about the whole time. ;-)


Thanks,
Roland
