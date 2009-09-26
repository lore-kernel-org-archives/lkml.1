Return-Path: <linux-kernel-owner+w=401wt.eu-S1752394AbZIZLof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752394AbZIZLof (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 07:44:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752187AbZIZLoe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 07:44:34 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:37061 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184AbZIZLoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 07:44:34 -0400
Date: Sat, 26 Sep 2009 13:35:58 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Brian Swetland <swetland@google.com>,
       Krzysztof Helt <krzysztof.h1@poczta.fm>,
       Rebecca Schultz Zavin <rebecca@android.com>,
       Dima Zavin <dima@android.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fbdev-devel@lists.sourceforge.net,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] video: includecheck fix: msm, mddi.c
Message-ID: <20090926113558.GA3105@ucw.cz>
References: <1253790872.5860.13.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253790872.5860.13.camel@ht.satnam>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-09-24 16:44:32, Jaswinder Singh Rajput wrote:
> 
> fix the following 'make includecheck' warning:
> 
>   drivers/video/msm/mddi.c: linux/delay.h is included more than once.
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>

Acked-by: Pavel Machek <pavel@ucw.cz>

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
