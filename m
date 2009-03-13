Return-Path: <linux-kernel-owner+w=401wt.eu-S1758865AbZCMCqn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758865AbZCMCqn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 22:46:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752371AbZCMCqc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 22:46:32 -0400
Received: from ozlabs.org ([203.10.76.45]:41574 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752348AbZCMCqb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 22:46:31 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PULL] x86 cpumask work
Date: Fri, 13 Mar 2009 13:16:26 +1030
User-Agent: KMail/1.11.1 (Linux/2.6.27-11-generic; KDE/4.2.1; i686; ; )
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, Mike Travis <travis@sgi.com>
References: <200903121453.45163.rusty@rustcorp.com.au> <200903130924.48885.rusty@rustcorp.com.au> <20090313005743.GE19544@elte.hu>
In-Reply-To: <20090313005743.GE19544@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903131316.26455.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 13 March 2009 11:27:43 Ingo Molnar wrote:
> 
> * Rusty Russell <rusty@rustcorp.com.au> wrote: 
> > Missing a core patch (it even got a compile warning with that 
> > config).
> So it's manual work and sometimes i notice them amongst a 
> boatload of other warnings, sometimes i dont.

Me too :(  I thought you were starting a de-warning tree?  I'd be
happy to send you patches (particularly, exporting deprecated symbols
should not give a warning!).

> > But there's something else wrong.  Firing up my 64-bit test 
> > box now.
> 
> Great - so you can reproduce. Thanks,

Yep, and I'm running some stress tests as well now.

Perhaps throw away that tree, and I'll feed you a new one (the
core patch needs to go at the front), but I can work either way.

Thanks,
Rusty.
