Return-Path: <linux-kernel-owner+w=401wt.eu-S1761081AbZFJUeq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761081AbZFJUeq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 16:34:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753558AbZFJUei
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 16:34:38 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:44329 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754895AbZFJUeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 16:34:37 -0400
Message-ID: <4A3017D1.5010708@cs.helsinki.fi>
Date: Wed, 10 Jun 2009 23:30:09 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       cl@linux-foundation.org, hannes@cmpxchg.org, mingo@elte.hu,
       mpm@selenic.com, npiggin@suse.de, yinghai@kernel.org
Subject: Re: [GIT PULL] Early boot SLAB for 2.6.31
References: <Pine.LNX.4.64.0906102311230.30444@melkki.cs.Helsinki.FI> <alpine.LFD.2.01.0906101331250.6847@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0906101331250.6847@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Wed, 10 Jun 2009, Pekka J Enberg wrote:
>> I already have patches for that but they are against the -tip tree so I think
>> we ought to just merge this series to mainline and fix everything up in
>> subsystem trees for 2.6.31 proper.
> 
> Hmm. Are there any reasons why the scheduler fixups can't go in this 
> series? Do they depend on other things in -tip?

The patches are rebased to -tip, yeah. I can do a version against your 
tree if you want but that will mean merge conflicts for Ingo. Hmm?

			Pekka
