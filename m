Return-Path: <linux-kernel-owner+w=401wt.eu-S1755321AbZHDIqP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321AbZHDIqP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 04:46:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755050AbZHDIqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 04:46:14 -0400
Received: from mail.gmx.net ([213.165.64.20]:54933 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753779AbZHDIqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 04:46:14 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+AuBlp+AiAsGRYJgOxK06FGfBndHo2nTmxEsk6Ms
	NOSFxxR1MWHt6f
Subject: Re: [patch] perf tools: allow top users to switch between weighted
 and individual counter display
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090804083219.GA18081@elte.hu>
References: <1248422990.28486.3.camel@marge.simson.net>
	 <1248425937.6987.0.camel@twins> <1248431821.9722.4.camel@marge.simson.net>
	 <20090802200049.GF24486@elte.hu>
	 <1249276178.17959.67.camel@marge.simson.net>
	 <1249374083.10069.18.camel@marge.simson.net>
	 <20090804083219.GA18081@elte.hu>
Content-Type: text/plain
Date: Tue, 04 Aug 2009 10:46:12 +0200
Message-Id: <1249375572.10642.3.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.64
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-04 at 10:32 +0200, Ingo Molnar wrote:
> * Mike Galbraith <efault@gmx.de> wrote:
> 
> > On Mon, 2009-08-03 at 07:09 +0200, Mike Galbraith wrote:
> > 
> > > Not sure I like waiting for input at start though, maybe just 
> > > display and sleep a couple seconds would be friendlier.
> > 
> > I find both really annoying, so just go straight into displaying.  
> > That kind of usage information belongs in the man page.  I've 
> > updated same to reflect the current implementation, and will 
> > submit separately.
> 
> yeah - will apply both patches, thanks Mike.

Thanks.

> I'm wondering, have you seen the 'tig' tool before? It puts the 
> console into raw mode too and has a rather pleasant text interface. 
> Since it's a relatively young project it might have a compact code 
> base that could be imported (assuming the license is compatible and 
> assuming what i say is true - have not checked yet).

No, I haven't.  I'll take a look (time time time) though, because I'd
like to make top fully interactive, and my code is... um er, somewhat
crude :)

	-Mike

