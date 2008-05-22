Return-Path: <linux-kernel-owner+w=401wt.eu-S1763001AbYEVWaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763001AbYEVWaZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 18:30:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758498AbYEVWaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 18:30:07 -0400
Received: from sous-sol.org ([216.99.217.87]:56497 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758758AbYEVWaG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 18:30:06 -0400
Date: Thu, 22 May 2008 15:29:13 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: Chris Wright <chrisw@sous-sol.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Andi Kleen <andi@firstfloor.org>, mingo@elte.hu, tglx@linutronix.de,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       roland@redhat.com, drepper@redhat.com, Hongjiu.lu@intel.com,
       linux-kernel@vger.kernel.org, arjan@linux.intel.com,
       rmk+lkml@arm.linux.org.uk, dan@debian.org, asit.k.mallick@intel.com
Subject: Re: [RFC] x86: xsave/xrstor support, ucontext_t extensions
Message-ID: <20080522222913.GC30402@sequoia.sous-sol.org>
References: <18482.53246.642835.894623@harpo.it.uu.se> <4832E705.2010900@zytor.com> <18482.60491.764019.292031@harpo.it.uu.se> <20080520175325.GE30034@linux-os.sc.intel.com> <4834BE39.2000904@zytor.com> <18485.13663.51624.694435@harpo.it.uu.se> <20080522205619.GB7998@linux-os.sc.intel.com> <4835DF64.6080104@zytor.com> <20080522213201.GF4018@sequoia.sous-sol.org> <18485.61551.199984.949174@harpo.it.uu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18485.61551.199984.949174@harpo.it.uu.se>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mikael Pettersson (mikpe@it.uu.se) wrote:
> Chris Wright writes:
> > hmm, what implications?  cpuid is dealt with already.
> 
> By whom?

I was thinking specifically vmx non-root.

thanks,
-chris
