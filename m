Return-Path: <linux-kernel-owner+w=401wt.eu-S1759479AbXHPMwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759479AbXHPMwS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 08:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755370AbXHPMwF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 08:52:05 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:39005 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755265AbXHPMwC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 08:52:02 -0400
Date: Thu, 16 Aug 2007 11:09:10 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Adrian Bunk <bunk@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] make kernel/power/main.c:suspend_enter() static
Message-ID: <20070816090910.GA11373@elf.ucw.cz>
References: <20070814212626.GB18945@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070814212626.GB18945@stusta.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2007-08-14 23:26:26, Adrian Bunk wrote:
> suspend_enter() can now become static.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

ACK.
							Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
