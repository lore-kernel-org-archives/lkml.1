Return-Path: <linux-kernel-owner+w=401wt.eu-S1755263AbYC1KQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263AbYC1KQ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 06:16:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755146AbYC1KQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 06:16:07 -0400
Received: from www.tglx.de ([62.245.132.106]:59514 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755121AbYC1KQG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 06:16:06 -0400
Date: Fri, 28 Mar 2008 11:15:42 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Chris Holvenstot <cholvenstot@comcast.net>
cc: Jiri Kosina <jkosina@suse.cz>, Kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.24-git15 Keyboard Issue?
In-Reply-To: <alpine.LFD.1.00.0802091255190.3145@apollo.tec.linutronix.de>
Message-ID: <alpine.LFD.1.00.0803281114300.3781@apollo.tec.linutronix.de>
References: <1202302978.9058.13.camel@popeye>  <Pine.LNX.4.64.0802061427410.30873@twin.jikos.cz>  <1202305740.9058.22.camel@popeye>  <Pine.LNX.4.64.0802061452210.30873@twin.jikos.cz>  <1202318666.6406.13.camel@popeye>  <Pine.LNX.4.64.0802071016220.30873@twin.jikos.cz>
  <1202381094.6179.0.camel@popeye>  <Pine.LNX.4.64.0802071149260.30955@jikos.suse.cz>  <alpine.LFD.1.00.0802071324410.9204@apollo.tec.linutronix.de>  <1202396868.6087.8.camel@popeye>  <alpine.LFD.1.00.0802071629350.9204@apollo.tec.linutronix.de> 
 <1202402704.6087.12.camel@popeye>  <alpine.LFD.1.00.0802071838110.9204@apollo.tec.linutronix.de>  <1202448975.6538.2.camel@popeye>  <alpine.LFD.1.00.0802091053350.3145@apollo.tec.linutronix.de> <1202553464.6386.7.camel@popeye>
 <alpine.LFD.1.00.0802091255190.3145@apollo.tec.linutronix.de>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris,

On Sat, 9 Feb 2008, Thomas Gleixner wrote:
> On Sat, 9 Feb 2008, Chris Holvenstot wrote:
> > [    0.000000] Kernel command line: root=UUID=4dc2e6b0-c980-418b-8ad0-98358e7ec47d ro quiet splash
> ....
> > [    0.004000] HPET not available
> 
> Ok. That confirms, that we never even try to touch hpet at all. So the
> mystery why "nohpet" on the kernel command line makes your problem go
> away is yet more mysterious.

Have we any update on this ? Does the problem persist with 2.6.25-rc7 ?

Thanks,

	tglx
