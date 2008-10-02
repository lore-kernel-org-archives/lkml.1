Return-Path: <linux-kernel-owner+w=401wt.eu-S1755412AbYJBWKv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412AbYJBWKv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 18:10:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754334AbYJBWKn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 18:10:43 -0400
Received: from kroah.org ([198.145.64.141]:54081 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753540AbYJBWKm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 18:10:42 -0400
Date: Thu, 2 Oct 2008 15:07:42 -0700
From: Greg KH <greg@kroah.com>
To: Jon Masters <jonathan@jonmasters.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Veen <arjan@infradead.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Steven Rostedt <rostedt@goodmis.org>, Sven Dietrich <sdietrich@suse.de>
Subject: Re: [RFC patch 0/5] genirq: add infrastructure for threaded
	interrupt handlers
Message-ID: <20081002220742.GC9201@kroah.com>
References: <20081001223213.078984344@linutronix.de> <1222908014.31183.67.camel@perihelion.int.jonmasters.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1222908014.31183.67.camel@perihelion.int.jonmasters.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 01, 2008 at 08:40:14PM -0400, Jon Masters wrote:
> On Wed, 2008-10-01 at 23:02 +0000, Thomas Gleixner wrote:
> 
> > I hope to have a real converted driver (aside of the dummy module used
> > for testing) ready real soon - as far as bugs/regressions stay out of
> > my way for a while. :)
> 
> Sven and I started poking at the various USB host drivers on the flight
> back from Plumbers. I'll see if I can convert over a few here on the
> systems that I have and send over some patches.

There's only 3, how hard could it be?  :)

/me runs away quickly
