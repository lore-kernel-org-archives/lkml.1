Return-Path: <linux-kernel-owner+w=401wt.eu-S1756079AbYJ3OwB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079AbYJ3OwB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 10:52:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755341AbYJ3Ovw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 10:51:52 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:56433 "EHLO UNKNOWN"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755015AbYJ3Ovw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 10:51:52 -0400
Date: Wed, 29 Oct 2008 15:00:56 +0100
From: Pavel Machek <pavel@suse.cz>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Antonino Daplas <adaplas@gmail.com>,
       Krzysztof Helt <krzysztof.h1@wp.pl>,
       linux-fbdev-devel@lists.sourceforge.net
Subject: Re: [PATCH RESEND] vgacon: remember scrollback buffer on console
	switch
Message-ID: <20081029140056.GA1469@ucw.cz>
References: <20081025195814.GD10932@joi> <20081025134615.36f7285f.akpm@linux-foundation.org> <20081025224247.GA25497@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081025224247.GA25497@joi>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > If so, it would be much much better to make this feature switchable at
> > runtime (module parameter/boot option or a /proc or /sys knob).
> 
> /sys knob seems to be the most flexible option.
> 
> /sys/class/vtconsole/vtconX/persistent_history? 0/1

0/number-of-lines-to-remember?
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
