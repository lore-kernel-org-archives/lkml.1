Return-Path: <linux-kernel-owner+w=401wt.eu-S1755719AbXLHBIc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755719AbXLHBIc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 20:08:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753258AbXLHBIY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 20:08:24 -0500
Received: from smtp3.Stanford.EDU ([171.67.20.26]:50731 "EHLO
	smtp3.stanford.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415AbXLHBIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 20:08:23 -0500
Subject: Re: [git pull] x86/hrtimer/acpi fixes
From: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Len Brown <lenb@kernel.org>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>
In-Reply-To: <20071207195958.GA12529@elte.hu>
References: <20071207183633.GC26778@elte.hu>
	 <1197053386.32023.13.camel@cmn3.stanford.edu>
	 <20071207185920.GA3006@elte.hu>
	 <1197055769.32023.22.camel@cmn3.stanford.edu>
	 <1197056910.32023.25.camel@cmn3.stanford.edu>
	 <20071207195958.GA12529@elte.hu>
Content-Type: text/plain
Date: Fri, 07 Dec 2007 17:08:20 -0800
Message-Id: <1197076100.32023.67.camel@cmn3.stanford.edu>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-12-07 at 20:59 +0100, Ingo Molnar wrote:
> * Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU> wrote:
> 
> > > Nope, it doesn't still getting "delay" and "xrun" messages galore.
> > 
> > Attached: configuration and dmesg output booting with idle=poll, 
> > reconfirmed that that makes the delay and xrun messages go away.
> 
> could you try the rolled up patch of various fixlets, ontop of current 
> -git? (it might even apply to -rc4) It includes some more stuff beyond 
> the ones in the pull request. (still being tested/reviewed)

I'll try but it will take me a while to figure git and do a package
build of it...

-- Fernando


