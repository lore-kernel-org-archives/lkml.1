Return-Path: <linux-kernel-owner+w=401wt.eu-S1758091AbXEaEDc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758091AbXEaEDc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 00:03:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751555AbXEaEDY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 00:03:24 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:11583 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbXEaEDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 00:03:24 -0400
X-IronPort-AV: i="4.14,596,1170651600"; 
   d="scan'208"; a="31299588:sNHT28725711"
Subject: Re: [PATCH] [RAMFS NOMMU]: a bug in ramfs_nommu_resize function,
	passing old size to vmtruncate
From: Bryan Wu <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Bryan Wu <bryan.wu@analog.com>, akpm@linux-foundation.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>
In-Reply-To: <alpine.LFD.0.98.0705302054380.26602@woody.linux-foundation.org>
References: <1180582315.10836.2.camel@roc-laptop>
	 <1180582528.10836.6.camel@roc-laptop>
	 <alpine.LFD.0.98.0705302054380.26602@woody.linux-foundation.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Ltd.
Date: Thu, 31 May 2007 12:03:22 +0800
Message-Id: <1180584202.6363.6.camel@roc-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-30 at 20:55 -0700, Linus Torvalds wrote:
> 
> On Thu, 31 May 2007, Bryan Wu wrote:
> > 
> > Sorry for sending this email several times , my git-send-email got some
> > problem.
> 
> The patch was whitespace-damaged (tabs had been turned into spaces).
> 
> But I fixed it up and applied it.
> 
> 		Linus

WOW, I tried git-send-email to you, Andrew and LKML. but got a warnning

--
W: unable to extract a valid address from: torvalds@linux-foundation.org akpm@linux-fundation.org linux-kernel@vger.kernel.org
--

But It can send email to Signed-off-by and Cc. I tried 3 times, David
got 3 same emails, sorry for this, -:).

Then I send out this patch manually in my evolution.
Maybe Copy & Paste introduced the whitespace.
I will go back to check my git's problem.

Thanks
-Bryan Wu
