Return-Path: <linux-kernel-owner+w=401wt.eu-S1750907AbXDLXEt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750907AbXDLXEt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 19:04:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752149AbXDLXEt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 19:04:49 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:56521 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907AbXDLXEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 19:04:48 -0400
Date: Thu, 12 Apr 2007 16:07:22 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/30] Use menuconfig objects
Message-Id: <20070412160722.e5e26039.randy.dunlap@oracle.com>
In-Reply-To: <20070412155012.789852c4.akpm@linux-foundation.org>
References: <Pine.LNX.4.61.0704102046520.32056@yvahk01.tjqt.qr>
	<20070412155012.789852c4.akpm@linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Apr 2007 15:50:12 -0700 Andrew Morton wrote:

> On Tue, 10 Apr 2007 21:17:40 +0200 (MEST)
> Jan Engelhardt <jengelh@linux01.gwdg.de> wrote:
> 
> > the following patch series turns some menus into menuconfigs, so they 
> > can be disabled whilst "walking" thorugh the parent menu
> 
> So I merged the 23 of these which survived review and which do not
> intersect with other outstanding work.
> 
> I don't think I have an opinion on whether the change is actually an
> improvement, and I don't get a clear sense of what others think.  Shrug.

I like them, but then I have made & sent similar patches in the past.


> If we're going to make this change, we should ensure that it is done
> kernel-wide, for UI consistency reasons.
> 
> If nothing else happens, I guess I'll spray these patches at the relevant
> maintainers in a couple of weeks time, see what sticks.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
