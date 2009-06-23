Return-Path: <linux-kernel-owner+w=401wt.eu-S1758426AbZFWWxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758426AbZFWWxl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 18:53:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752574AbZFWWxc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 18:53:32 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34873 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757435AbZFWWxb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 18:53:31 -0400
Date: Tue, 23 Jun 2009 21:37:51 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Paul Smith <paul@mad-scientist.net>
Cc: Roland McGrath <roland@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] coredump: Retry writes where appropriate
Message-ID: <20090623193751.GA28836@redhat.com>
References: <20090601184608.6379440c@lxorguk.ukuu.org.uk> <20090601182305.GA16372@redhat.com> <20090601203845.B010DFC3C7@magilla.sf.frob.com> <20090601223241.GA26788@redhat.com> <20090601230210.C0B15FC3C7@magilla.sf.frob.com> <20090602000850.GA31064@redhat.com> <20090603070939.4E31CFC333@magilla.sf.frob.com> <20090604031544.GA23930@redhat.com> <20090604171458.F0DC7FC3C3@magilla.sf.frob.com> <1245778278.9022.21.camel@psmith-ubeta.netezza.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245778278.9022.21.camel@psmith-ubeta.netezza.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23, Paul Smith wrote:
>
> Did you have any more time to look into this?  I'm currently using my
> patch and it's OK for my purposes but I'll be happy to test any proposal
> you come up with, if you like, so I can drop my patch in the future.

Thanks for reminding...

I'll try to make the patch this or next week.

Oleg.

