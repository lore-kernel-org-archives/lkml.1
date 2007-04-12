Return-Path: <linux-kernel-owner+w=401wt.eu-S1750740AbXDLWu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750740AbXDLWu3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 18:50:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751884AbXDLWu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 18:50:29 -0400
Received: from smtp.osdl.org ([65.172.181.24]:35717 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750740AbXDLWu2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 18:50:28 -0400
Date: Thu, 12 Apr 2007 15:50:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/30] Use menuconfig objects
Message-Id: <20070412155012.789852c4.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.61.0704102046520.32056@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704102046520.32056@yvahk01.tjqt.qr>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Apr 2007 21:17:40 +0200 (MEST)
Jan Engelhardt <jengelh@linux01.gwdg.de> wrote:

> the following patch series turns some menus into menuconfigs, so they 
> can be disabled whilst "walking" thorugh the parent menu

So I merged the 23 of these which survived review and which do not
intersect with other outstanding work.

I don't think I have an opinion on whether the change is actually an
improvement, and I don't get a clear sense of what others think.  Shrug.

If we're going to make this change, we should ensure that it is done
kernel-wide, for UI consistency reasons.

If nothing else happens, I guess I'll spray these patches at the relevant
maintainers in a couple of weeks time, see what sticks.

