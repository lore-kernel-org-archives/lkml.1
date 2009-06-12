Return-Path: <linux-kernel-owner+w=401wt.eu-S1759131AbZFLQlz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759131AbZFLQlz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 12:41:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753111AbZFLQlr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 12:41:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48770 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751206AbZFLQlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 12:41:47 -0400
Date: Fri, 12 Jun 2009 09:41:06 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Vegard Nossum <vegard.nossum@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] kmemcheck for mainline
In-Reply-To: <alpine.LFD.2.01.0906120933120.3237@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0906120939250.3237@localhost.localdomain>
References: <20090612132443.GA24002@damson.ad.medicalresearch.no> <alpine.LFD.2.01.0906120933120.3237@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 12 Jun 2009, Linus Torvalds wrote:
> 
> This release, I'm only going to pull trees that don't do crazy shit.

>From another thread yesterday:

> http://www.mail-archive.com/dri-devel@lists.sourceforge.net/msg39091.html
> http://lkml.org/lkml/2008/5/16/540

Especially that first one, and in that first one, especially about the 
"Don't merge upstream/downstream code at random points."

		Linus
