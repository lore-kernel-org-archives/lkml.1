Return-Path: <linux-kernel-owner+w=401wt.eu-S1758297AbZDFUWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758297AbZDFUWt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 16:22:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756922AbZDFUWg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 16:22:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48076 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755882AbZDFUWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 16:22:36 -0400
Date: Mon, 6 Apr 2009 13:20:02 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Hua Zhong <hzhong@gmail.com>
cc: "'Theodore Tso'" <tytso@mit.edu>, "'Jens Axboe'" <jens.axboe@oracle.com>,
       "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 0/8][RFC] IO latency/throughput fixes
In-Reply-To: <002501c9b6f3$f85b4910$e911db30$@com>
Message-ID: <alpine.LFD.2.00.0904061319370.7443@localhost.localdomain>
References: <1239022088-29002-1-git-send-email-jens.axboe@oracle.com> <alpine.LFD.2.00.0904060803141.4023@localhost.localdomain> <20090406151054.GD5178@kernel.dk> <alpine.LFD.2.00.0904060840080.3863@localhost.localdomain> <20090406183157.GD7376@mit.edu>
 <alpine.LFD.2.00.0904061255160.4134@localhost.localdomain> <002501c9b6f3$f85b4910$e911db30$@com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 6 Apr 2009, Hua Zhong wrote:
>
> Grr..making writeback as default would break people's setup that relies on
> the ordered semantics, especially in the embedded world. It's a big no-no.

We could make it a config option, perhaps.

		Linus
