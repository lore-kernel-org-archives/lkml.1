Return-Path: <linux-kernel-owner+w=401wt.eu-S1763500AbXJZPev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763500AbXJZPev (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 11:34:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754394AbXJZPeo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 11:34:44 -0400
Received: from mx2.redhat.com ([66.187.237.31]:49760 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752946AbXJZPen (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 11:34:43 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18210.2314.57767.962503@zebedee.pink>
Date: Fri, 26 Oct 2007 16:34:34 +0100
From: Andrew Haley <aph@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Bart Van Assche <bart.vanassche@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Is gcc thread-unsafe?
In-Reply-To: <alpine.LFD.0.999.0710260756260.30120@woody.linux-foundation.org>
References: <e2e108260710260729x4603211cgb68d7434ce1e54e9@mail.gmail.com>
	<e2e108260710260740k27210c4fu2f75d5fb31ccdccc@mail.gmail.com>
	<alpine.LFD.0.999.0710260756260.30120@woody.linux-foundation.org>
X-Mailer: VM 7.19 under Emacs 22.0.93.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds writes:
 
 > So my basic worry about gcc is in fact none of the individual
 > technical problems themselves - those can be fixed. No, the problem
 > I've seen in gcc is that _some_ of the developers seem to be total
 > d*ckheads when it comes to "language definition", and seem to think
 > that it's more important to read the language spec like a lawyer
 > than it is to solve actual user problems.

Well, yeah.  I know what you mean.  However, at this moment, some gcc
developers are trying really hard not to be total d*ckheads about this
issue, but get gcc fixed.  Give us a chance.

Andrew.

-- 
Red Hat UK Ltd, Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE, UK
Registered in England and Wales No. 3798903
