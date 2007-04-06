Return-Path: <linux-kernel-owner+w=401wt.eu-S1767571AbXDFKal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767571AbXDFKal (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 06:30:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767572AbXDFKal
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 06:30:41 -0400
Received: from one.firstfloor.org ([213.235.205.2]:36624 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767571AbXDFKak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 06:30:40 -0400
Date: Fri, 6 Apr 2007 12:30:38 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       virtualization <virtualization@lists.osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Define EFLAGS_IF
Message-ID: <20070406103038.GA32440@one.firstfloor.org>
References: <1174533374.2713.104.camel@localhost.localdomain> <46159256.1040705@zytor.com> <461592AA.4060103@goop.org> <46159480.20108@zytor.com> <20070406004839.GA27668@one.firstfloor.org> <46159D08.9030400@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46159D08.9030400@zytor.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 05, 2007 at 06:06:16PM -0700, H. Peter Anvin wrote:
> Andi Kleen wrote:
> >
> >No processor.h is such a hodgepodge of unrelated stuff that any
> >splitting up is a good thing.
> >
> 
> Fair enough.  However, I'd still like to see the X86_CR* constants 
> moved, too (and constants added for at least CR0 as well.)

Send patches then.

-Andi
