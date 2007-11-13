Return-Path: <linux-kernel-owner+w=401wt.eu-S1756754AbXKMMOJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756754AbXKMMOJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 07:14:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754220AbXKMMNx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 07:13:53 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42842 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754044AbXKMMNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 07:13:51 -0500
Date: Tue, 13 Nov 2007 04:12:59 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Miller <davem@davemloft.net>
Cc: protasnb@gmail.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       alsa-devel@alsa-project.org, linux-ide@vger.kernel.org,
       linux-pcmcia@lists.infradead.org, linux-input@atrey.karlin.mff.cuni.cz,
       bugme-daemon@bugzilla.kernel.org
Subject: Re: [BUG] New Kernel Bugs
Message-Id: <20071113041259.79c9a8c5.akpm@linux-foundation.org>
In-Reply-To: <20071113.035824.40509981.davem@davemloft.net>
References: <20071113031553.3c7b5c16.akpm@linux-foundation.org>
	<20071113.033946.114918709.davem@davemloft.net>
	<20071113034916.2556edd7.akpm@linux-foundation.org>
	<20071113.035824.40509981.davem@davemloft.net>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Nov 2007 03:58:24 -0800 (PST) David Miller <davem@davemloft.net> wrote:

> From: Andrew Morton <akpm@linux-foundation.org>
> Date: Tue, 13 Nov 2007 03:49:16 -0800
> 
> > Do you believe that our response to bug reports is adequate?
> 
> Do you feel that making us feel and look like shit helps?
> 

That doesn't answer my question.

See, first we need to work out whether we have a problem.  If we do this,
then we can then have a think about what to do about it.

I tried to convince the 2006 KS attendees that we have a problem and I
resoundingly failed.  People seemed to think that we're doing OK.

But it appears that data such as this contradicts that belief.


This is not a minor matter.  If the kernel _is_ slowly deteriorating then
this won't become readily apparent until it has been happening for a number
of years.  By that stage there will be so much work to do to get us back to
an acceptable level that it will take a huge effort.  And it will take a
long time after that for the kerel to get its reputation back.

So it is important that we catch deterioration *early* if it is happening.

