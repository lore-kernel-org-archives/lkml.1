Return-Path: <linux-kernel-owner+w=401wt.eu-S1762751AbYDVSR5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762751AbYDVSR5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 14:17:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752822AbYDVSRo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 14:17:44 -0400
Received: from tomts43-srv.bellnexxia.net ([209.226.175.110]:39633 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759131AbYDVSRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 14:17:43 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlMFAF/IDUhMROPA/2dsb2JhbACBUqtx
Date: Tue, 22 Apr 2008 14:12:39 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Kyle McMartin <kyle@mcmartin.ca>
Cc: Sam Ravnborg <sam@ravnborg.org>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       kyle@parisc-linux.org, matthew@wil.cx, grundler@parisc-linux.org,
       linux-parisc@vger.kernel.org
Subject: Re: [RFC patch 5/9] PARISC remove -traditional
Message-ID: <20080422181239.GA14156@Krystal>
References: <20080422172404.502954084@polymtl.ca> <20080422172842.036035445@polymtl.ca> <20080422180009.GJ19802@phobos.i.cabal.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080422180009.GJ19802@phobos.i.cabal.ca>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:12:19 up 53 days, 14:23,  5 users,  load average: 0.64, 0.40,
	0.43
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Kyle McMartin (kyle@mcmartin.ca) wrote:
> On Tue, Apr 22, 2008 at 01:24:09PM -0400, Mathieu Desnoyers wrote:
> > Subject: [RFC patch 5/9] Re: [PATCH] Stringify support commas
> >  > This is a no-no for those archs that still use -traditional.
> >  > > I dunno if this is a problem for you at the moment and the
> >  > > right fix is anyway to nuke -traditional.
> >  > > 
> >  > >     Sam
> > 
> > Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> > CC: Sam Ravnborg <sam@ravnborg.org>
> > CC: kyle@parisc-linux.org
> > CC: matthew@wil.cx
> > CC: grundler@parisc-linux.org
> > CC: linux-parisc@vger.kernel.org
> 
> no. more work needs to be done to remove it. i have a patch already.
> 
> it would likely be smarter to just use a private stringify for the C
> code for now.

OK, this is what I wanted to know.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
