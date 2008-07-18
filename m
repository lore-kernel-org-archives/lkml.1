Return-Path: <linux-kernel-owner+w=401wt.eu-S1759077AbYGRWm0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759077AbYGRWm0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 18:42:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753909AbYGRWmT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 18:42:19 -0400
Received: from gw.goop.org ([64.81.55.164]:36671 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753382AbYGRWmS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 18:42:18 -0400
Message-ID: <48811C3A.4040207@goop.org>
Date: Fri, 18 Jul 2008 15:42:02 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] generic ipi function calls: wait on alloc failure	fallback
References: <487D0719.9000503@goop.org> <20080715214819.GA23588@elte.hu> <487D1E1E.9060609@goop.org> <20080718221922.GC31073@elte.hu>
In-Reply-To: <20080718221922.GC31073@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> ok. I doubt there's much we can do at this stage - the code looks fine. 
> If it's some recently added core kernel problem sooner or later some 
> workload or hw will come about that shows it in a more debuggable 
> manner.

Yep.  It has been rock solid for me lately, even doing traditionally 
bug-inducing things like save/restore.

    J

