Return-Path: <linux-kernel-owner+w=401wt.eu-S1752121AbXJUB7m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121AbXJUB7m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 21:59:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750814AbXJUB7f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 21:59:35 -0400
Received: from mx2.suse.de ([195.135.220.15]:33986 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750763AbXJUB7e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 21:59:34 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: git/cscope with x86 merge
Date: Sat, 20 Oct 2007 22:44:00 +0200
User-Agent: KMail/1.9.6
Cc: Sam Ravnborg <sam@ravnborg.org>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <86802c440710151245s7d12a45fpfdaa041546d965e@mail.gmail.com> <20071020191534.GA8774@uranus.ravnborg.org> <alpine.LFD.0.999.0710201232100.10525@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0710201232100.10525@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710202244.00671.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Try with "-p".
> 
> It's possible (nay, likely) that "next" has the bug where "--follow" 
> without a patch generating thing (-p or --stat or one of the other flags 
> that enable diffs) doesn't work at all.

It's not only next. The latest release (1.5.3.4) has this problem.

-Andi
