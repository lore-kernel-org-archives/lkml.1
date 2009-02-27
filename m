Return-Path: <linux-kernel-owner+w=401wt.eu-S1760949AbZB0Vya@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760949AbZB0Vya (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 16:54:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757729AbZB0VyW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 16:54:22 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:43355 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755049AbZB0VyV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 16:54:21 -0500
Subject: Re: How much of a mess does OpenVZ make? ;) Was: What can OpenVZ
	do?
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-api@vger.kernel.org,
       containers@lists.linux-foundation.org, hpa@zytor.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       viro@zeniv.linux.org.uk, mpm@selenic.com,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, tglx@linutronix.de, xemul@openvz.org
In-Reply-To: <20090227215749.GA3453@x200.localdomain>
References: <1234462282.30155.171.camel@nimitz>
	 <1234467035.3243.538.camel@calx>
	 <20090212114207.e1c2de82.akpm@linux-foundation.org>
	 <1234475483.30155.194.camel@nimitz>
	 <20090212141014.2cd3d54d.akpm@linux-foundation.org>
	 <1234479845.30155.220.camel@nimitz>
	 <20090226162755.GB1456@x200.localdomain> <20090226173302.GB29439@elte.hu>
	 <20090226223112.GA2939@x200.localdomain>
	 <1235751298.26788.372.camel@nimitz>
	 <20090227215749.GA3453@x200.localdomain>
Content-Type: text/plain
Date: Fri, 27 Feb 2009 13:54:15 -0800
Message-Id: <1235771655.26788.400.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-02-28 at 00:57 +0300, Alexey Dobriyan wrote:
> On Fri, Feb 27, 2009 at 08:14:58AM -0800, Dave Hansen wrote:
> > On Fri, 2009-02-27 at 01:31 +0300, Alexey Dobriyan wrote:
> > > > I think the main question is: will we ever find ourselves in the 
> > > > future saying that "C/R sucks, nobody but a small minority uses 
> > > > it, wish we had never merged it"? I think the likelyhood of that 
> > > > is very low. I think the current OpenVZ stuff already looks very 
> > > > useful, and i dont think we've realized (let alone explored) all 
> > > > the possibilities yet.
> > > 
> > > This is collecting and start of dumping part of cleaned up OpenVZ C/R
> > > implementation, FYI.
> > 
> > Are you just posting this to show how you expect c/r to look eventually?
> > Or are you proposing this as an alternative to what Oren has bee
> > posting?
> 
> This is under discussion right now.

Here as in LKML and containers@?  Or do you mean among the
OpenVZ/Virtuozzo folks?

The reason I ask is that we have gone through several rounds of
community review over the last few months with Oren's code, and I'd hate
to throw that away unless there's something wrong with it.  Is there
something wrong with it?

-- Dave

