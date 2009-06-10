Return-Path: <linux-kernel-owner+w=401wt.eu-S1761322AbZFJUe7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761322AbZFJUe7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 16:34:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759101AbZFJUeu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 16:34:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53553 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753558AbZFJUet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 16:34:49 -0400
Date: Wed, 10 Jun 2009 13:33:30 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Pekka J Enberg <penberg@cs.helsinki.fi>
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       cl@linux-foundation.org, hannes@cmpxchg.org, mingo@elte.hu,
       mpm@selenic.com, npiggin@suse.de, yinghai@kernel.org
Subject: Re: [GIT PULL] Early boot SLAB for 2.6.31
In-Reply-To: <alpine.LFD.2.01.0906101331250.6847@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0906101332440.6847@localhost.localdomain>
References: <Pine.LNX.4.64.0906102311230.30444@melkki.cs.Helsinki.FI> <alpine.LFD.2.01.0906101331250.6847@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 10 Jun 2009, Linus Torvalds wrote:
> 
> Hmm. Are there any reasons why the scheduler fixups can't go in this 
> series? Do they depend on other things in -tip?

[ .. because otherwise we'll inevitably just get unnecessary bug-reports 
  about this all - harmless or not, that message would be annoying and 
  certainly cause people to panic. ]

		Linus
