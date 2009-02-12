Return-Path: <linux-kernel-owner+w=401wt.eu-S1758197AbZBLCRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758197AbZBLCRV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 21:17:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757866AbZBLCRA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 21:17:00 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:47089 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755656AbZBLCRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 21:17:00 -0500
Date: Wed, 11 Feb 2009 21:16:57 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 0/7][RFC] function graph tracer port to PowerPC
In-Reply-To: <20090212015503.GA4697@nowhere>
Message-ID: <alpine.DEB.1.10.0902112116340.13595@gandalf.stny.rr.com>
References: <20090212011051.265346435@goodmis.org> <20090212015503.GA4697@nowhere>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 12 Feb 2009, Frederic Weisbecker wrote:

> On Wed, Feb 11, 2009 at 08:10:51PM -0500, Steven Rostedt wrote:
> > 
> > The following set of patches are RFC and not for inclusion
> > (unless everyone is fine with them as is).
> > 
> > This is the port to PowerPC of the function graph tracer that was written
> > by Frederic Weisbecker for the x86 architecture.  It is broken up
> > into a series of logical steps.
> > 
> > 1) get generic code ready for other archs
> > 2) get PowerPC 64-bit working with just static function tracing
> > 3) get PowerPC 64-bit working with dynamic function tracing
> > 4) get PowerPC 32-bit working with just static function tracing
> > 5) get PowerPC 32-bit working with dynamic function tracing
> > 
> > (with some clean ups in between)
> > 
> 
> 
> Thanks a lot Steven!
> I'm sad to not having a Power Pc to test it...

If you had a PowerPC, I doubt I would have been the one to port it ;-)

-- Steve

