Return-Path: <linux-kernel-owner+w=401wt.eu-S1755613AbYBIJ45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755613AbYBIJ45 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 04:56:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752568AbYBIJ4s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 04:56:48 -0500
Received: from www.tglx.de ([62.245.132.106]:59923 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752448AbYBIJ4r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 04:56:47 -0500
Date: Sat, 9 Feb 2008 10:56:15 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Chris Holvenstot <cholvenstot@comcast.net>
cc: Jiri Kosina <jkosina@suse.cz>, Kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.24-git15 Keyboard Issue?
In-Reply-To: <1202448975.6538.2.camel@popeye>
Message-ID: <alpine.LFD.1.00.0802091053350.3145@apollo.tec.linutronix.de>
References: <1202302978.9058.13.camel@popeye>  <Pine.LNX.4.64.0802061427410.30873@twin.jikos.cz>  <1202305740.9058.22.camel@popeye>  <Pine.LNX.4.64.0802061452210.30873@twin.jikos.cz>  <1202318666.6406.13.camel@popeye>  <Pine.LNX.4.64.0802071016220.30873@twin.jikos.cz>
  <1202381094.6179.0.camel@popeye>  <Pine.LNX.4.64.0802071149260.30955@jikos.suse.cz>  <alpine.LFD.1.00.0802071324410.9204@apollo.tec.linutronix.de>  <1202396868.6087.8.camel@popeye>  <alpine.LFD.1.00.0802071629350.9204@apollo.tec.linutronix.de> 
 <1202402704.6087.12.camel@popeye>  <alpine.LFD.1.00.0802071838110.9204@apollo.tec.linutronix.de> <1202448975.6538.2.camel@popeye>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Feb 2008, Chris Holvenstot wrote:
> I believe that the following is the output you are looking for - sorry
> for the delay - between doctors and grandkids I was ready for a few pain
> pills and a long nap.  

Hope you feel better again !
 
> I suspect you often feel the same way after dealing with some who post
> here.

:)

> [    0.000000] Kernel command line: root=UUID=4dc2e6b0-c980-418b-8ad0-98358e7ec47d ro quiet splash nohpet
....
> [    0.004000] HPET not available

Which is expected, as we have "nohpet" on the kernel command line.

Can you provide the output without the "nohpet" on the kernel command
line please ?

Thanks,
	tglx
