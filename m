Return-Path: <linux-kernel-owner+w=401wt.eu-S1762161AbXGEWuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762161AbXGEWuZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 18:50:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759582AbXGEWuO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 18:50:14 -0400
Received: from zrtps0kp.nortel.com ([47.140.192.56]:59283 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759022AbXGEWuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 18:50:13 -0400
Message-ID: <468D757F.5000804@nortel.com>
Date: Thu, 05 Jul 2007 16:49:35 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Ernie Petrides <petrides@redhat.com>
CC: Clemens Koller <clemens.koller@anagramm.de>,
       Chris Wright <chrisw@sous-sol.org>, Uli Luckas <u.luckas@road.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21.5 june 30th to july 1st date hang?
References: <200707052228.l65MSdvA025440@pasta.boston.redhat.com>
In-Reply-To: <200707052228.l65MSdvA025440@pasta.boston.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Jul 2007 22:49:39.0046 (UTC) FILETIME=[C4A30860:01C7BF56]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ernie Petrides wrote:

> Only kernels built with the CONFIG_HIGH_RES_TIMERS option enabled were
> vulnerable.

As I mentioned in my post to Thomas, we have high res timers disabled 
and were still affected.  Granted, our kernel has been modified so it is 
possible that vanilla would not be affected....I haven't tested it.

Chris
