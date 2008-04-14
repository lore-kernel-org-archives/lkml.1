Return-Path: <linux-kernel-owner+w=401wt.eu-S1755333AbYDNKL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333AbYDNKL0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 06:11:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751507AbYDNKLP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 06:11:15 -0400
Received: from one.firstfloor.org ([213.235.205.2]:56353 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423AbYDNKLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 06:11:14 -0400
Date: Mon, 14 Apr 2008 12:16:08 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Willy Tarreau <w@1wt.eu>
Cc: Andi Kleen <andi@firstfloor.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Tilman Schmidt <tilman@imap.cc>, Valdis.Kletnieks@vt.edu,
       Mark Lord <lkml@rtr.ca>, David Miller <davem@davemloft.net>,
       jesper.juhl@gmail.com, yoshfuji@linux-ipv6.org, jeff@garzik.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Reporting bugs and bisection
Message-ID: <20080414101608.GA18662@one.firstfloor.org>
References: <47FEADCB.7070104@rtr.ca> <22880.1207943922@turing-police.cc.vt.edu> <47FFE5DA.8000709@imap.cc> <200804132040.12138.rjw@sisk.pl> <20080413184730.GD8474@1wt.eu> <874pa4wyfj.fsf@basil.nowhere.org> <20080414100018.GA10378@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080414100018.GA10378@1wt.eu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> And most of all, the reporter would not feel like the bisection is
> the default response !

Well it is proportional to the quality of the bug report. If it 
very vague enough often there is no other good answer. If it
comes with already some debugging or good logs or a good test case 
etc. I agree just saying "please bisect" is not very nice (but
sometimes it might be still needed if code review doesn't find
anything)

Perhaps there should be a document somewhere explaining this which
can be easily pointed to.

-Andi
