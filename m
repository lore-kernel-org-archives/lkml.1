Return-Path: <linux-kernel-owner+w=401wt.eu-S1762638AbXEUVUP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762638AbXEUVUP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 17:20:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761912AbXEUVTu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 17:19:50 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47021 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761778AbXEUVTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 17:19:49 -0400
Date: Mon, 21 May 2007 14:07:35 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Chuck Ebbert <cebbert@redhat.com>
cc: Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       stable@kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [patch 00/69] -stable review
In-Reply-To: <4652070D.3090509@redhat.com>
Message-ID: <alpine.LFD.0.98.0705211406000.3890@woody.linux-foundation.org>
References: <20070521191612.800400000@sous-sol.org>
 <4652070D.3090509@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 21 May 2007, Chuck Ebbert wrote:
> 
> What happened to:
> 
> "Fix ACPI suspend / device suspend ordering problem"
> 52ade9b3b97fd3bea42842a056fe0786c28d0555

I would suggest waiting on problem reports for that one a bit longer.

Maybe it fixes everything, and has no downsides. But the problem it fixed 
isn't new, and the order change certainly has the _potential_ to be scary.

Do we have reports of that one fixing a lot of machines? I know of only 
one person it made a difference for..

		Linus
