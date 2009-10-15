Return-Path: <linux-kernel-owner+w=401wt.eu-S1762642AbZJOKvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762642AbZJOKvd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 06:51:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762626AbZJOKvc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 06:51:32 -0400
Received: from ozlabs.org ([203.10.76.45]:58718 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762102AbZJOKvc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 06:51:32 -0400
Date: Thu, 15 Oct 2009 21:46:33 +1100
From: Anton Blanchard <anton@samba.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Ravikiran G Thirumalai <kiran@scalex86.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jens Axboe <axboe@kernel.dk>
Subject: Re: Latest vfs scalability patch
Message-ID: <20091015104633.GG4808@kryten>
References: <20091006064919.GB30316@wotan.suse.de> <20091015100854.GA19948@kryten> <20091015103958.GA3127@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091015103958.GA3127@wotan.suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
Hi Nick,

> Nice looking graph, thanks! Did you use the rcu patch there as
> well? (my open-close testing chokes RCU but your system might
> be managing to keep outstanding callbacks below the threshold)

Yep, I am running with the RCU patch but forgot to mention it :)

Anton
