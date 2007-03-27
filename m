Return-Path: <linux-kernel-owner+w=401wt.eu-S1753880AbXC0OYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880AbXC0OYQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 10:24:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753881AbXC0OYQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 10:24:16 -0400
Received: from ns2.suse.de ([195.135.220.15]:60262 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753880AbXC0OYP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 10:24:15 -0400
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Nick Piggin <npiggin@suse.de>, Ravikiran G Thirumalai <kiran@scalex86.org>,
       Ingo Molnar <mingo@elte.hu>, Nikita Danilov <nikita@clusterfs.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch] queued spinlocks (i386)
References: <20070325155407.GA497@tv-sign.ru>
From: Andi Kleen <andi@firstfloor.org>
Date: 27 Mar 2007 17:22:41 +0200
In-Reply-To: <20070325155407.GA497@tv-sign.ru>
Message-ID: <p73slbq4sou.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@tv-sign.ru> writes:
> 
> Makes sense? Or stupid?

Interesting idea. Probably worth testing.

-Andi
