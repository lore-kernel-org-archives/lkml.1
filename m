Return-Path: <linux-kernel-owner+w=401wt.eu-S1758571AbZFJTBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758571AbZFJTBf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 15:01:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756917AbZFJTB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 15:01:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45103 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753157AbZFJTB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 15:01:26 -0400
Date: Wed, 10 Jun 2009 11:59:29 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Pekka J Enberg <penberg@cs.helsinki.fi>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, cl@linux-foundation.com,
       mingo@elte.hu, hannes@cmpxchg.org, mpm@selenic.com, npiggin@suse.de,
       yinghai@kernel.org
Subject: Re: [PATCH 3/3] vmalloc: use kzalloc() instead of alloc_bootmem()
In-Reply-To: <Pine.LNX.4.64.0906102058060.28361@melkki.cs.Helsinki.FI>
Message-ID: <alpine.LFD.2.01.0906101158440.6847@localhost.localdomain>
References: <Pine.LNX.4.64.0906102058060.28361@melkki.cs.Helsinki.FI>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



ACK on the whole series. Feel free to push it to me asap, so that we can 
get any potential issues found and sorted out early.

		Linus
