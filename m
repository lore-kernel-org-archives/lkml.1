Return-Path: <linux-kernel-owner+w=401wt.eu-S1756759AbXJCATU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756759AbXJCATU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 20:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753214AbXJCATM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 20:19:12 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59580 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752374AbXJCATK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 20:19:10 -0400
Date: Tue, 2 Oct 2007 17:18:55 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Bill Davidsen <davidsen@tmr.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, casey@schaufler-ca.com,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Version 3 (2.6.23-rc8) Smack: Simplified Mandatory Access
   Control Kernel
In-Reply-To: <20071003011033.5bfc9165@the-village.bc.nu>
Message-ID: <alpine.LFD.0.999.0710021714100.3579@woody.linux-foundation.org>
References: <46FEEBD4.5050401@schaufler-ca.com> <20070930011618.ccb8351b.akpm@linux-foundation.org>
 <Xine.LNX.4.64.0710010146100.13671@us.intercode.com.au>
 <alpine.LFD.0.999.0710010803280.3579@woody.linux-foundation.org>
 <1191253239.7672.76.camel@moss-spartans.epoch.ncsc.mil>
 <alpine.LFD.0.999.0710010854120.3579@woody.linux-foundation.org>
 <4702B1D5.5050502@tmr.com> <20071003011033.5bfc9165@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 3 Oct 2007, Alan Cox wrote:
> 
> Smack seems a perfectly good simple LSM module, its clean, its based upon
> credible security models and sound theory (unlike AppArmor).

The problem with SELinux isn't the theory. It's the practice. 

IOW, it's too hard to use.

Apparently Ubuntu is giving up on it too, for that reason.

And what some people seem to have trouble admitting is that theory counts 
for nothing, if the practice isn't there.

So quite frankly, the SELinux people would look at whole lot smarter if 
they didn't blather on about "theory".

		Linus
