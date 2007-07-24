Return-Path: <linux-kernel-owner+w=401wt.eu-S1761212AbXGXUXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761212AbXGXUXz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 16:23:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754134AbXGXUXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 16:23:47 -0400
Received: from smtp2.Stanford.EDU ([171.67.20.25]:45951 "EHLO
	smtp2.stanford.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753702AbXGXUXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 16:23:46 -0400
Subject: Re: v2.6.22.1-rt5
From: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
To: Ingo Molnar <mingo@elte.hu>
Cc: Rui Nuno Capela <rncbc@rncbc.org>, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20070724200546.GA24964@elte.hu>
References: <20070723210236.GA25104@elte.hu> <46A51D9E.8040104@rncbc.org>
	 <20070724073932.GA18740@elte.hu>
	 <1185305679.16400.17.camel@cmn3.stanford.edu>
	 <1185305725.16400.19.camel@cmn3.stanford.edu>
	 <20070724200546.GA24964@elte.hu>
Content-Type: text/plain
Date: Tue, 24 Jul 2007 13:23:43 -0700
Message-Id: <1185308623.16400.28.camel@cmn3.stanford.edu>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-24 at 22:05 +0200, Ingo Molnar wrote:
> * Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU> wrote:
> 
> > On Tue, 2007-07-24 at 12:34 -0700, Fernando Lopez-Lezcano wrote:
> > > On Tue, 2007-07-24 at 09:39 +0200, Ingo Molnar wrote:
> > > > * Rui Nuno Capela <rncbc@rncbc.org> wrote:
> > > > 
> > > > > Maybe I was too quick, but `make all` on is failing here:
> > > > 
> > > > does -rt6 work better?
> > > 
> > > Hmmm, -rt6 seems to be gone... was about to download it and it
> > > dissapeared. 
> > 
> > Never mind, I see it migrated back to the main page. 
> 
> apparently you caught that 3 seconds window where the .23-rc1-rt1 
> release script moved old patches into the older/ directory :-)

Yup, good timing... :-) Hard to do again...
(BTW, will you keep 2.6.22.x patches going for a while?)
-- Fernando


