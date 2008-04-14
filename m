Return-Path: <linux-kernel-owner+w=401wt.eu-S1762868AbYDNRMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762868AbYDNRMR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 13:12:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759138AbYDNRMF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 13:12:05 -0400
Received: from vena.lwn.net ([206.168.112.25]:41918 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758982AbYDNRMF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 13:12:05 -0400
To: "Bart Van Assche" <bart.vanassche@gmail.com>
Cc: "Matthew Wilcox" <matthew@wil.cx>, "Roland Dreier" <rdreier@cisco.com>,
       "Peter Zijlstra" <peterz@infradead.org>,
       "Ingo Oeser" <ioe-lkml@rameria.de>,
       "Daniel Walker" <dwalker@mvista.com>, linux-kernel@vger.kernel.org,
       "Linus Torvalds" <torvalds@osdl.org>, "Ingo Molnar" <mingo@elte.hu>
Subject: Re: API documentation (was [PATCH] Replace completions with semaphores)
From: corbet@lwn.net (Jonathan Corbet)
In-reply-to: Your message of "Sun, 13 Apr 2008 16:55:25 +0200."
             <e2e108260804130755r3c2cac0fnaa0c570707f2b53b@mail.gmail.com> 
Date: Mon, 14 Apr 2008 11:12:04 -0600
Message-ID: <16641.1208193124@vena.lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bart Van Assche <bart.vanassche@gmail.com> wrote:

> The LWN book is getting outdated after all the 2.6 kernel API changes,
> and the page with 2.6 kernel API changes was last updated six months
> ago. Where can a kernel developer find up to date information about
> kernel programming ?

The failure to update the API changes page is just me not managing to
get around to it.  I'll do my best to take care of that in the next few
days.  Apologies for that.

Updating LDD (which isn't really "the LWN book" though it's hosted here)
will take a little longer.  I'd like to find a way to produce an LDD4
with quality at least as good as LDD3, but which doesn't fill the world
with immediately-obsolete bricks of dead trees.  Still working on it...

jon
