Return-Path: <linux-kernel-owner+w=401wt.eu-S933115AbXCMLlm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933115AbXCMLlm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 07:41:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933161AbXCMLlm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 07:41:42 -0400
Received: from depni.sinp.msu.ru ([213.131.7.21]:54043 "EHLO depni.sinp.msu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933115AbXCMLll (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 07:41:41 -0400
To: Mike Galbraith <efault@gmx.de>
Cc: Con Kolivas <kernel@kolivas.org>, Ingo Molnar <mingo@elte.hu>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH][RSDL-mm 0/7] RSDL cpu scheduler for 2.6.21-rc3-mm2
References: <200703111457.17624.kernel@kolivas.org>
	<1173778398.6810.21.camel@Homer.simpson.net>
	<20070313093914.GA10533@elte.hu>
	<200703132106.08878.kernel@kolivas.org>
	<1173785006.8561.19.camel@Homer.simpson.net>
From: Serge Belyshev <belyshev@depni.sinp.msu.ru>
Date: Tue, 13 Mar 2007 14:41:39 +0300
In-Reply-To: <1173785006.8561.19.camel@Homer.simpson.net> (Mike Galbraith's message of "Tue\, 13 Mar 2007 12\:23\:26 +0100")
Message-ID: <87bqix5q18.fsf@depni.sinp.msu.ru>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/23.0.0 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Galbraith <efault@gmx.de> writes:

[snip]
> It seems to be a plain linear slowdown.  The lurchiness I'm experiencing
> varies in intensity, and is impossible to quantify.  I see neither
> lurchiness nor slowdown in mainline through -j8.
>
Whaa? make -j8 on mainline makes my desktop box completely useless.

Please reconsider your statement.
