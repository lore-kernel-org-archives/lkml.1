Return-Path: <linux-kernel-owner+w=401wt.eu-S1754487AbYADPFQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487AbYADPFQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 10:05:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752329AbYADPFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 10:05:04 -0500
Received: from mx2.suse.de ([195.135.220.15]:40343 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752113AbYADPFD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 10:05:03 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Subject: Re: [PATCH x86] [12/16] Optimize lock prefix switching to run less frequently
Date: Fri, 4 Jan 2008 16:04:57 +0100
User-Agent: KMail/1.9.6
Cc: "Thomas Gleixner" <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>
References: <20080103442.621670000@suse.de> <200801041539.27370.ak@suse.de> <84144f020801040702x23469d69n8e3643221d38dfb0@mail.gmail.com>
In-Reply-To: <84144f020801040702x23469d69n8e3643221d38dfb0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801041604.57964.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 January 2008 16:02:37 Pekka Enberg wrote:
> Hi Andi,
> 
> On Jan 4, 2008 4:39 PM, Andi Kleen <ak@suse.de> wrote:
> > > The kernel process request that _all_ contributors run their patches
> > > through checkpath.pl and fix the problems.
> >
> > That's new. When and by whom was that rule been introduced? And with what
> > rationale?
> 
> Not be new to anyone trying to sneak a patch past Andrew for the past
> few months...

I got several in and I don't remember anybody complaining about this
before Ingo/Thomas.

-Andi


