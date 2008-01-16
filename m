Return-Path: <linux-kernel-owner+w=401wt.eu-S1757569AbYAPB6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757569AbYAPB6S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 20:58:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756599AbYAPB6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 20:58:05 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:45148 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755013AbYAPB6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 20:58:04 -0500
Date: Wed, 16 Jan 2008 10:57:16 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Pavel Machek <pavel@ucw.cz>, Marcelo Tosatti <marcelo@kvack.org>
Subject: Re: [RFC][PATCH 3/5] add /dev/mem_notify device
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Daniel Spang <daniel.spang@gmail.com>,
       Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20080115221627.GC1565@elf.ucw.cz>
References: <20080115100029.1178.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20080115221627.GC1565@elf.ucw.cz>
Message-Id: <20080116105102.11B1.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel

> > 	err = poll(&pollfds, 1, -1); // wake up at low memory
> > 
> >         ...
> > </usage example>
> 
> Nice, this is really needed for openmoko, zaurus, etc....
> 
> But this changelog needs to go into Documentation/...
> 
> ...and /dev/mem_notify is really a bad name. /dev/memory_low?
> /dev/oom?

thank you for your kindful advise.

but..

to be honest, my english is very limited.
I can't make judgments name is good or not.

Marcelo, What do you think his idea?




