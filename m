Return-Path: <linux-kernel-owner+w=401wt.eu-S964810AbXCPOH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964810AbXCPOH2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 10:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964812AbXCPOH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 10:07:28 -0400
Received: from mail.gmx.net ([213.165.64.20]:54604 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S964810AbXCPOH1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 10:07:27 -0400
X-Provags-ID: V01U2FsdGVkX19Es0ohlZNEk2xH9xsjBIFjBkuTBEqx59+EGa3KF7
	GoryLDtnRFfWch
Subject: Re: RSDL development plans
From: Mike Galbraith <efault@gmx.de>
To: Con Kolivas <kernel@kolivas.org>
Cc: ck@vds.kolivas.org, Ingo Molnar <mingo@elte.hu>,
       Al Boldi <a1426z@gawab.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <200703170059.54320.kernel@kolivas.org>
References: <200703042335.26785.a1426z@gawab.com>
	 <200703162325.05691.kernel@kolivas.org>
	 <1174052523.8039.7.camel@Homer.simpson.net>
	 <200703170059.54320.kernel@kolivas.org>
Content-Type: text/plain
Date: Fri, 16 Mar 2007 15:07:18 +0100
Message-Id: <1174054038.14632.0.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-03-17 at 00:59 +1100, Con Kolivas wrote:
> On Saturday 17 March 2007 00:42, Mike Galbraith wrote:
> > On Fri, 2007-03-16 at 23:25 +1100, Con Kolivas wrote:
> > > The good news is that in order to stay sane I've found ways of optimising
> > > my computing position and could work for short stints on the rsdl code.
> > > So I'll be releasing a new version shortly.
> >
> > Can you please make an incremental diff as well?  That will make it
> > easier to see what changes have taken place, and make it easier to
> > integrate those into hacked-upon trees.
> 
> They're already there in the subdirs.
> ie
> http://ck.kolivas.org/patches/staircase-deadline/2.6.20.3/2.6.20.3-rsdl-0.30-0.31.patch
> http://ck.kolivas.org/patches/staircase-deadline/2.6.21-rc3/2.6.21-rc3-rsdl-0.30-0.31.patch
> http://ck.kolivas.org/patches/staircase-deadline/2.6.21-rc3-mm2/2.6.21-rc3-mm2-rsdl-0.30-0.31.patch

Ah, got it.  Thanks.

	-Mike

