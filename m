Return-Path: <linux-kernel-owner+w=401wt.eu-S1754954AbXEJWjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754954AbXEJWjT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 18:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760818AbXEJWiy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 18:38:54 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57161 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760552AbXEJWix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 18:38:53 -0400
Date: Thu, 10 May 2007 15:38:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/30] Use menuconfig objects
Message-Id: <20070510153847.c6048c04.akpm@linux-foundation.org>
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
> can be disabled whilst "walking" thorugh the parent menu (check the 
> videos [1], [2] to see what I mean), enabling for disabling lots of 
> options _quickly_.

Well Martin's little tromp through the Kconfig menus meant that I had to
repair pretty much every one of these patches.  Could you please have a
look at http://userweb.kernel.org/~akpm/menuconfig/, see if I screwed
anything up?

