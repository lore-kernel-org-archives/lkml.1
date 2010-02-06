Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754962Ab0BFJdO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Feb 2010 04:33:14 -0500
Received: from 1wt.eu ([62.212.114.60]:56153 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754291Ab0BFJdN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Feb 2010 04:33:13 -0500
Date: Sat, 6 Feb 2010 10:31:44 +0100
From: Willy Tarreau <w@1wt.eu>
To: Sven Joachim <svenjoac@gmx.de>
Cc: Greg KH <greg@kroah.com>, stable@kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       stable-review@kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Stable-review] [stable] [PATCH] Fix 'flush_old_exec()/setup_new_exec()' split
Message-ID: <20100206093144.GE23328@1wt.eu>
References: <1265245849.3362.1.camel@localhost> <1265256174.2952.11.camel@localhost> <alpine.LFD.2.00.1002032135380.3707@localhost.localdomain> <1265272174.2952.20.camel@localhost> <20100204143848.GB15438@kroah.com> <87sk9gbzzt.fsf@turtle.gmx.de> <20100204185752.GA18595@kroah.com> <87iqacdcfj.fsf@turtle.gmx.de> <20100206084936.GA4441@kroah.com> <87mxzm1zyr.fsf@turtle.gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mxzm1zyr.fsf@turtle.gmx.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 06, 2010 at 10:21:48AM +0100, Sven Joachim wrote:
> On 2010-02-06 09:49 +0100, Greg KH wrote:
> 
> > I think this was the sysctl issue, and have released a 2.6.32.8-rc2.
> > Can you test that to verify if it fixes your crash or not?
> 
> Yes, it fixes the issue.  I'm using -rc2 right now, did not notice any
> problems so far.

FWIW, it's running fine here too. I've tried to boot on a miniature
init launcher I have (statically linked one) and did not have any issue.

Willy

