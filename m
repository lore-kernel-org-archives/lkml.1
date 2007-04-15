Return-Path: <linux-kernel-owner+w=401wt.eu-S1752064AbXDOCsm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064AbXDOCsm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 22:48:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752192AbXDOCsm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 22:48:42 -0400
Received: from wr-out-0506.google.com ([64.233.184.234]:53579 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064AbXDOCsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 22:48:41 -0400
Message-ID: <5640c7e00704141948n5f82cd8fl64092c720954175f@mail.gmail.com>
Date: Sun, 15 Apr 2007 14:48:40 +1200
From: "Ian McDonald" <ian.mcdonald@jandi.co.nz>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Subject: Re: {Spam?} Re: {Spam?} [PATCH] NET: Remove obsolete traffic shaper code.
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org, "Adrian Bunk" <bunk@stusta.de>
In-Reply-To: <Pine.LNX.4.64.0704141959190.22316@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0704141925310.22138@localhost.localdomain>
	 <5640c7e00704141646k44334de9g99dc509bf96bac5f@mail.gmail.com>
	 <Pine.LNX.4.64.0704141959190.22316@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/15/07, Robert P. J. Day <rpjday@mindspring.com> wrote:
> in fact, according to this:
>
> http://lkml.org/lkml/2006/1/13/139
>
> that notice was put in the feature removal file well over a year ago,
> during 2.6.15.  so that would seem to be more than adequate time for
> everyone to prepare for it.  but it must have been deleted from that
> file since then as well.

Yes and that was never merged and so was resent on January 19th, 2006:
http://www.nabble.com/-2.6-patch--schedule-SHAPER-for-removal-t949871.html

At that point people debated about it being too short notice and the
patch never went in.

I therefore think we can't just remove with NO notice.

Ian
-- 
Web: http://wand.net.nz/~iam4/
Blog: http://iansblog.jandi.co.nz
WAND Network Research Group
