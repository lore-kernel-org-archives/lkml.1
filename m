Return-Path: <linux-kernel-owner+w=401wt.eu-S1755790AbYHYMHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755790AbYHYMHo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 08:07:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753573AbYHYMHf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 08:07:35 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:26973 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753253AbYHYMHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 08:07:35 -0400
Message-ID: <48B2A081.6010300@hp.com>
Date: Mon, 25 Aug 2008 08:07:29 -0400
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [Bug #11342] Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c - bisected
References: <mzBsPw3QUOF.A.87F.wZGsIB@albercik> <VSpL6AnBTS.A.q9H.6aGsIB@albercik> <alpine.LFD.1.10.0808231257310.3363@nehalem.linux-foundation.org> <48B06FE6.8060404@linux.intel.com>
In-Reply-To: <48B06FE6.8060404@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:

> 
> Wonder what gcc is in use?
> (newer ones tend to be a ton better... but maybe Alex is using a really
> old one)

I'm running Ubuntu 8.04 w/ gcc:

gcc (GCC) 4.2.3 (Ubuntu 4.2.3-2ubuntu7)

Alan
