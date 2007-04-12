Return-Path: <linux-kernel-owner+w=401wt.eu-S1752082AbXDLXRY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082AbXDLXRY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 19:17:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753400AbXDLXRY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 19:17:24 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:52059 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752082AbXDLXRX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 19:17:23 -0400
Date: Fri, 13 Apr 2007 01:16:35 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/30] Use menuconfig objects
In-Reply-To: <20070412155012.789852c4.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.61.0704130114350.14441@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704102046520.32056@yvahk01.tjqt.qr>
 <20070412155012.789852c4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Apr 12 2007 15:50, Andrew Morton wrote:
>On Tue, 10 Apr 2007 21:17:40 +0200 (MEST)
>Jan Engelhardt <jengelh@linux01.gwdg.de> wrote:
>
>> the following patch series turns some menus into menuconfigs, so they 
>> can be disabled whilst "walking" thorugh the parent menu
>
>So I merged the 23 of these which survived review and which do not
>intersect with other outstanding work.
>
>I don't think I have an opinion on whether the change is actually an
>
>If we're going to make this change, we should ensure that it is done
>kernel-wide, for UI consistency reasons.

If time permits, I'll go through the rest of the menus I find
eligible for menuconfig-izing.

Does it help to base them on -mm to work better with outstanding work?


Thanks,
Jan
-- 
