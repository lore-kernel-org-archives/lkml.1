Return-Path: <linux-kernel-owner+w=401wt.eu-S1754344AbYG2XaB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344AbYG2XaB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 19:30:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752055AbYG2X3x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 19:29:53 -0400
Received: from mga03.intel.com ([143.182.124.21]:5274 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752040AbYG2X3x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 19:29:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,274,1215414000"; 
   d="scan'208";a="26854442"
Date: Tue, 29 Jul 2008 16:29:52 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "roland@redhat.com" <roland@redhat.com>,
       "drepper@redhat.com" <drepper@redhat.com>,
       "mikpe@it.uu.se" <mikpe@it.uu.se>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [patch 0/9] x86, xsave: xsave/xrstor support
Message-ID: <20080729232951.GB11223@linux-os.sc.intel.com>
References: <20080729172917.185593000@linux-os.sc.intel.com> <488FA318.3040905@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <488FA318.3040905@zytor.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2008 at 04:09:12PM -0700, H. Peter Anvin wrote:
> Applied as tip:x86/xsave.
> 
> I should warn I had to do quite a bit of manual fixup in order to
> disentangle it from other changes in -tip, so please test it out; I
> compile-tested it but for obvious reasons can't do more than that at the
> moment.

hpa, these patches just apply fine to tip/master. Can you please arrange
the tip/x86/xsave tree accordingly? or do I need to do something else
to smooth this process?

thanks,
suresh
