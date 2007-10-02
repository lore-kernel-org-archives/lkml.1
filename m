Return-Path: <linux-kernel-owner+w=401wt.eu-S1755234AbXJBJVv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234AbXJBJVv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 05:21:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752149AbXJBJVo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 05:21:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33731 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751737AbXJBJVn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 05:21:43 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Linux 2.6.23-rc9 and a heads-up for the 2.6.24 series..
Date: Tue, 2 Oct 2007 11:21:36 +0200
User-Agent: KMail/1.9.6
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Greg KH <greg@kroah.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.0.999.0710012029400.3579@woody.linux-foundation.org > <alpine.LRH.0.999.0710021019310.23586@www.tglx.de>
In-Reply-To: <alpine.LRH.0.999.0710021019310.23586@www.tglx.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710021121.36443.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 02 October 2007 11:17:02 Thomas Gleixner wrote:
> > This is also a good time to warn about the fact that we're doing the x86 
> > merge very soon (as in the next day or two) after 2.6.23 is out, so if you 
> > have pending patches for the next series that touch arch/i386 or x86-64, 
> > you should get in touch with Thomas Gleixner and Ingo Molnar, who are the 
> > keepers of the merge scripts, and will help you prepare..


Yes I have ~100 patches for arch/x86_64, arch/i386

Should I just drop them?

-Andi
