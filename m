Return-Path: <linux-kernel-owner+w=401wt.eu-S1753700AbZDUFvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753700AbZDUFvS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 01:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751366AbZDUFvE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 01:51:04 -0400
Received: from ozlabs.org ([203.10.76.45]:49269 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751064AbZDUFvE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 01:51:04 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v2 0/4] Add support for compiling with -ffunction-sections -fdata-sections
Date: Tue, 21 Apr 2009 15:20:56 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
Cc: Tim Abbott <tabbott@mit.edu>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@mit.edu>, Waseem Daher <wdaher@mit.edu>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, Jeff Arnold <jbarnold@mit.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jon Masters <jonathan@jonmasters.org>
References: <1238973278-31735-1-git-send-email-tabbott@mit.edu> <alpine.DEB.1.10.0904201255080.30705@vinegar-pot.mit.edu> <alpine.LFD.2.00.0904201637280.2199@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0904201637280.2199@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904211520.57861.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Apr 2009 09:10:58 am Linus Torvalds wrote:
> 
> On Mon, 20 Apr 2009, Tim Abbott wrote:
> >
> > Is there a problem that is preventing this -ffunction-sections patch 
> > series from being merged?
> 
> Quite frankly, every time I see something like this, I shudder.

It's the section name cleanup which is the invasive part, and I'd like to
see merged now.

I don't care so much about actually flipping the option on.

Thanks,
Rusty.
