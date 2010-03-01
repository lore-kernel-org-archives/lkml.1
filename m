Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751536Ab0CAP1f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 10:27:35 -0500
Received: from dsl-67-204-24-19.acanac.net ([67.204.24.19]:36857 "EHLO
	emergent.ellipticsemi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751154Ab0CAP1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 10:27:33 -0500
Date: Mon, 1 Mar 2010 10:13:00 -0500
From: Nick Bowler <nbowler@elliptictech.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Stephen Rothwell <sfr@canb.auug.org.au>,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       roland@redhat.com, suresh.b.siddha@intel.com, tglx@linutronix.de,
       hjl.tools@gmail.com, Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next requirements
Message-ID: <20100301151300.GA14825@emergent.ellipticsemi.com>
Mail-Followup-To: Ingo Molnar <mingo@elte.hu>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Stephen Rothwell <sfr@canb.auug.org.au>, mingo@redhat.com,
	hpa@zytor.com, linux-kernel@vger.kernel.org, roland@redhat.com,
	suresh.b.siddha@intel.com, tglx@linutronix.de, hjl.tools@gmail.com,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus <torvalds@linux-foundation.org>
References: <20100211195614.886724710@sbs-t61.sc.intel.com>
 <201002271323.14402.rjw@sisk.pl>
 <20100227124710.GA21164@elte.hu>
 <201002272007.43042.rjw@sisk.pl>
 <20100228072357.GB14205@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100228072357.GB14205@elte.hu>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08:23 Sun 28 Feb     , Ingo Molnar wrote:
> 
> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > > In fact those rare ways of building and booting the kernel i mentioned are 
> > > probably used _more_ than half of the architectures that linux-next 
> > > build-tests ...
> > 
> > I don't know and you don't know either.  That's just pure speculation and 
> > therefore meaningless.
> 
> We know various arch (and hardware) usage stats, such as:
> 
>   http://smolt.fedoraproject.org/static/stats/stats.html
> 
> Today's stats, done amongst users who are willing to opt in to the Smolt 
> daemon:
> 
>        x86: 99.7%
>    powerpc: 0.3%
> 
> x86 used to be 99.5 a year ago, so the world has become even more x86-centric.

This only tells us that _smolt users_ have become even more x86-centric.
As a self-selected sample, it is very likely a poor representative of
"the world" and any such extrapolation is indeed "pure speculation".

-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
