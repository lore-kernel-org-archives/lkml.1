Return-Path: <linux-kernel-owner+w=401wt.eu-S1754010AbYAWQea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010AbYAWQea (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 11:34:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752447AbYAWQeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 11:34:21 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:33032 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433AbYAWQeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 11:34:20 -0500
Subject: Re: CONFIG_MARKERS
From: Jon Masters <jonathan@jonmasters.org>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: "Frank Ch. Eigler" <fche@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Hellwig <hch@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20080123150140.GA14066@Krystal>
References: <1201029235.18144.62.camel@perihelion>
	 <y0modbdnt4e.fsf@ton.toronto.redhat.com> <20080123031005.GA16766@Krystal>
	 <1201061860.25284.28.camel@perihelion> <20080123131442.GA6562@redhat.com>
	 <20080123144811.GA12296@Krystal>  <20080123150140.GA14066@Krystal>
Content-Type: text/plain
Organization: World Organi[sz]ation Of Broken Dreams
Date: Wed, 23 Jan 2008 11:33:43 -0500
Message-Id: <1201106023.25284.58.camel@perihelion>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-01-23 at 10:01 -0500, Mathieu Desnoyers wrote:

> if (!(mod->taints & (TAINT_FORCED_MODULE | TAINT_PROPRIETARY_MODULE)))
> 
> Which remembers me to never write code before my first coffee in the
> morning ;)

I switched to decaf and joined a gym...for someone who used to have 23
shots of espresso some days, it's a change.

But more importantly, are you going to take care of patching this up, or
shall I send something out? It's up to you.

Jon.


