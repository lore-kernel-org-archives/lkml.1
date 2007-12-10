Return-Path: <linux-kernel-owner+w=401wt.eu-S1754148AbXLJPj7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148AbXLJPj7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 10:39:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751860AbXLJPjv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 10:39:51 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38693 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751982AbXLJPju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 10:39:50 -0500
Date: Mon, 10 Dec 2007 07:38:51 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Tejun Heo <htejun@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.24-rc4-git5: Reported regressions from 2.6.23
In-Reply-To: <20071210033832.3eefbc52@the-village.bc.nu>
Message-ID: <alpine.LFD.0.9999.0712100736370.12046@woody.linux-foundation.org>
References: <200712080340.49546.rjw@sisk.pl> <20071208015227.3a1c7fae.akpm@linux-foundation.org> <475B9270.6070902@gmail.com> <20071209134217.7ff02dd2@the-village.bc.nu> <alpine.LFD.0.9999.0712091036380.12046@woody.linux-foundation.org>
 <20071209220132.53268368@the-village.bc.nu> <alpine.LFD.0.9999.0712091736450.12046@woody.linux-foundation.org> <20071210033832.3eefbc52@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 10 Dec 2007, Alan Cox wrote:
> 
> And as I keep pointing out but you keep ignoring - not doing it breaks
> even more things, by a factor of quite a lot.

But we've never done it before in libata, right?

So the "not doing it breaks" argument is about stuff that isn't 
regressions.

Can you really not see the difference?

		Linus
