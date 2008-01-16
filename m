Return-Path: <linux-kernel-owner+w=401wt.eu-S1758838AbYAPELW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758838AbYAPELW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 23:11:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756875AbYAPELO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 23:11:14 -0500
Received: from kanga.kvack.org ([66.96.29.28]:44987 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756332AbYAPELN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 23:11:13 -0500
Date: Wed, 16 Jan 2008 02:13:32 -0200
From: Marcelo Tosatti <marcelo@kvack.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Pavel Machek <pavel@ucw.cz>, Marcelo Tosatti <marcelo@kvack.org>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Daniel Spang <daniel.spang@gmail.com>, Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH 3/5] add /dev/mem_notify device
Message-ID: <20080116041332.GA30877@dmt>
References: <20080115100029.1178.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20080115221627.GC1565@elf.ucw.cz> <20080116105102.11B1.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080116105102.11B1.KOSAKI.MOTOHIRO@jp.fujitsu.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2008 at 10:57:16AM +0900, KOSAKI Motohiro wrote:
> Hi Pavel
> 
> > > 	err = poll(&pollfds, 1, -1); // wake up at low memory
> > > 
> > >         ...
> > > </usage example>
> > 
> > Nice, this is really needed for openmoko, zaurus, etc....
> > 
> > But this changelog needs to go into Documentation/...
> > 
> > ...and /dev/mem_notify is really a bad name. /dev/memory_low?
> > /dev/oom?
> 
> thank you for your kindful advise.
> 
> but..
> 
> to be honest, my english is very limited.
> I can't make judgments name is good or not.
> 
> Marcelo, What do you think his idea?

"mem_notify" sounds alright, but I don't really care.

Notify:

To give notice to; inform: notified the citizens of the curfew by
posting signs.
