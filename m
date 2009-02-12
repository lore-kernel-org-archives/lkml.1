Return-Path: <linux-kernel-owner+w=401wt.eu-S1759491AbZBLR1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759491AbZBLR1n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 12:27:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757051AbZBLR1f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 12:27:35 -0500
Received: from casper.infradead.org ([85.118.1.10]:56322 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755017AbZBLR1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 12:27:34 -0500
Subject: Re: git-send-email
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Oeser <ioe-lkml@rameria.de>
Cc: Junio C Hamano <gitster@pobox.com>, L-K <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <200902121825.35021.ioe-lkml@rameria.de>
References: <1234451714.10603.22.camel@laptop>
	 <200902121825.35021.ioe-lkml@rameria.de>
Content-Type: text/plain
Date: Thu, 12 Feb 2009 18:27:23 +0100
Message-Id: <1234459643.10603.33.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-12 at 18:25 +0100, Ingo Oeser wrote:
> Hi,
> 
> On Thursday 12 February 2009, Peter Zijlstra wrote:
> > could we change the default of git-send-email to --no-chain-reply-to?
> > These incredibly deep mail threads are a nuisance.
> 
> No, they are great, if you like to skip over a topic, you are not
> interested in at all!

A single depth thread can do that too.

> If you don't like it, just switch off thread in your mailer and
> don't force this on everybody else!

That's something quite different. I quite like the subject grouping,
what I don't like is not being able to read distinct subject lines
because the n-th email in the patch series in so deep the threading in
my mailer can't display the subject anymore.

