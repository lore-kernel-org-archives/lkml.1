Return-Path: <linux-kernel-owner+w=401wt.eu-S1763256AbYEWAgj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763256AbYEWAgj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 20:36:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759252AbYEWAg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 20:36:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49964 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755327AbYEWAg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 20:36:28 -0400
Message-ID: <48361080.7020007@zytor.com>
Date: Thu, 22 May 2008 17:32:00 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Chris Wright <chrisw@sous-sol.org>
CC: Mikael Pettersson <mikpe@it.uu.se>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Andi Kleen <andi@firstfloor.org>, mingo@elte.hu, tglx@linutronix.de,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       roland@redhat.com, drepper@redhat.com, Hongjiu.lu@intel.com,
       linux-kernel@vger.kernel.org, arjan@linux.intel.com,
       rmk+lkml@arm.linux.org.uk, dan@debian.org, asit.k.mallick@intel.com
Subject: Re: [RFC] x86: xsave/xrstor support, ucontext_t extensions
References: <18482.53246.642835.894623@harpo.it.uu.se> <4832E705.2010900@zytor.com> <18482.60491.764019.292031@harpo.it.uu.se> <20080520175325.GE30034@linux-os.sc.intel.com> <4834BE39.2000904@zytor.com> <18485.13663.51624.694435@harpo.it.uu.se> <20080522205619.GB7998@linux-os.sc.intel.com> <4835DF64.6080104@zytor.com> <20080522213201.GF4018@sequoia.sous-sol.org> <18485.61551.199984.949174@harpo.it.uu.se> <20080522222913.GC30402@sequoia.sous-sol.org>
In-Reply-To: <20080522222913.GC30402@sequoia.sous-sol.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Wright wrote:
> * Mikael Pettersson (mikpe@it.uu.se) wrote:
>> Chris Wright writes:
>>> hmm, what implications?  cpuid is dealt with already.
>> By whom?
> 
> I was thinking specifically vmx non-root.

You're assuming the presence *and use* of VMX.

	-hpa
