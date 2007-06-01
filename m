Return-Path: <linux-kernel-owner+w=401wt.eu-S1760951AbXFAQMH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760951AbXFAQMH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 12:12:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756019AbXFAQL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 12:11:57 -0400
Received: from waste.org ([66.93.16.53]:33261 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755908AbXFAQL4 (ORCPT <rfc822;Linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 12:11:56 -0400
Date: Fri, 1 Jun 2007 11:11:11 -0500
From: Matt Mackall <mpm@selenic.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "K.R. Foley" <kr@cybsft.com>, Linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: patch-2.6.21.3-rt9 misnamed?
Message-ID: <20070601161111.GM11166@waste.org>
References: <465EE33B.4070502@cybsft.com> <20070531153821.GA712@elte.hu> <465EFE31.30904@cybsft.com> <20070531200109.GA8715@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070531200109.GA8715@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31, 2007 at 10:01:09PM +0200, Ingo Molnar wrote:
> 
> * K.R. Foley <kr@cybsft.com> wrote:
> 
> > Ingo Molnar wrote:
> > > * K.R. Foley <kr@cybsft.com> wrote:
> > > 
> > >> Ingo,
> > >>
> > >> I believe that patch-2.6.21.3-rt9 is misnamed. It applies cleanly to 
> > >> 2.6.21 but seems to contain stuff that is already in 2.6.21.3.
> > > 
> > > yes - it includes all of 2.6.21.3.
> > > 
> > > 	Ingo
> > > 
> > 
> > So actually it is not really misnamed, it's just done a bit 
> > differently than previous versions. Sorry.
> 
> yeah. Maybe we should make the 2.6.21.3 -rt patches relative to 2.6.21.3 
> - but that would be one extra patching step for people who already have 
> a 2.6.21 tree. But ... maybe that makes the most sense after all.

Including 2.6.21.3 in your patch will break ketchup.

-- 
Mathematics is the supreme nostalgia of our time.
