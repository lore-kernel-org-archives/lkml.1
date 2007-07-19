Return-Path: <linux-kernel-owner+w=401wt.eu-S939497AbXGSQTQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939497AbXGSQTQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 12:19:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762199AbXGSQTB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 12:19:01 -0400
Received: from gw.goop.org ([64.81.55.164]:35759 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757982AbXGSQTA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 12:19:00 -0400
Message-ID: <469F8EBE.5020703@goop.org>
Date: Thu, 19 Jul 2007 09:18:06 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>, stable@kernel.org,
       Greg KH <greg@kroah.com>, Chris Wright <chrisw@sous-sol.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Jan Glauber <jang@linux.vnet.ibm.com>, Andi Kleen <ak@suse.de>
Subject: Re: [patch] sched: implement cpu_clock(cpu) high-speed time	source,
 take #2
References: <469F75AF.5080000@goop.org> <20070719143528.GA8278@elte.hu> <469F793E.6030006@goop.org> <20070719145058.GA11971@elte.hu> <469F7D7A.204@goop.org> <20070719150955.GA19373@elte.hu> <469F8179.2060802@goop.org> <20070719154254.GA24225@elte.hu> <20070719154449.GA28998@elte.hu> <469F8D28.1010304@goop.org> <20070719161643.GA5153@elte.hu>
In-Reply-To: <20070719161643.GA5153@elte.hu>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> yeah, that's the idea.
>   

Good.  But the real question: does it help Andrew?

    J
