Return-Path: <linux-kernel-owner+w=401wt.eu-S1761906AbZFJVDb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761906AbZFJVDb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 17:03:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758300AbZFJVDV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 17:03:21 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:53204 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757198AbZFJVDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 17:03:20 -0400
Message-ID: <4A301E8C.8070602@cs.helsinki.fi>
Date: Wed, 10 Jun 2009 23:58:52 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       cl@linux-foundation.org, hannes@cmpxchg.org, mpm@selenic.com,
       npiggin@suse.de, yinghai@kernel.org
Subject: Re: [GIT PULL] Early boot SLAB for 2.6.31
References: <Pine.LNX.4.64.0906102311230.30444@melkki.cs.Helsinki.FI> <alpine.LFD.2.01.0906101331250.6847@localhost.localdomain> <4A3017D1.5010708@cs.helsinki.fi> <20090610204318.GA8147@elte.hu> <84144f020906101347y3e250f4bme2d1c60dd5993ffc@mail.gmail.com> <20090610205026.GC8147@elte.hu> <20090610205749.GA9321@elte.hu>
In-Reply-To: <20090610205749.GA9321@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> How about this: i can send the scheduler and x86 bits to Linus right 
> now, that should make it possible to have a clean base for you and 
> no interactions with anything pending?

Sure, we can do that too. Whatever works for you guys, it's not a huge 
deal for me to rebase the series.

			Pekka
