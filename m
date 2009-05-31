Return-Path: <linux-kernel-owner+w=401wt.eu-S1758664AbZEaK0B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758664AbZEaK0B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 06:26:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758246AbZEaKZu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 06:25:50 -0400
Received: from 219-87-157-169.static.tfn.net.tw ([219.87.157.169]:59201 "EHLO
	mswedge2.sunplus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758178AbZEaKZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 06:25:48 -0400
X-Greylist: delayed 1300 seconds by postgrey-1.27 at vger.kernel.org; Sun, 31 May 2009 06:25:48 EDT
In-Reply-To: <200905141044.56426.arnd@arndb.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Kyle McMartin <kyle@mcmartin.ca>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Thomas Gleixner <tglx@linutronix.de>, torvalds@linux-foundation.org
MIME-Version: 1.0
Subject: Re: [PATCH 0/14] score - New architecure port to SunplusCT S+CORE
X-Mailer: Lotus Notes Release 6.5 September 26, 2003
Message-ID: <OFFD33A4F9.B19BF27B-ON482575C7.0036D2B4-482575C7.00373F30@sunplusct.com>
From: liqin.chen@sunplusct.com
Date: Sun, 31 May 2009 17:59:27 +0800
X-MIMETrack: Serialize by Router on ctmail01/SunplusCT(Release 7.0.3FP1|February 24, 2008) at 2009/05/31 ?? 05:59:28,
	Serialize complete at 2009/05/31 ?? 05:59:28
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

> Have you had a chance to look at the asm-generic header files I posted
> a few times?
> 
> ...
> Please tell me if you find problems in the generic header files during
> the conversion.
> 

I can't clone the linux/kernel/git/arnd/asm-generic.git repository, 
and have not test score arch code until now.

In addition, next time I send the patches mail should base on
linux/kernel/git/arnd/asm-generic.git or
linux/kernel/git/sfr/linux-next.git?

Liqin

