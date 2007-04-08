Return-Path: <linux-kernel-owner+w=401wt.eu-S1030512AbXDJOQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030512AbXDJOQt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 10:16:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030524AbXDJOQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 10:16:49 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2111 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030512AbXDJOQr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 10:16:47 -0400
Date: Sun, 8 Apr 2007 16:58:18 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Maxim Uvarov <muvarov@ru.mvista.com>
Cc: Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org
Subject: Re: Performance Stats: Kernel patch
Message-ID: <20070408165818.GA5055@ucw.cz>
References: <46124E93.2000408@ru.mvista.com> <16797.1175641303@turing-police.cc.vt.edu> <4613A4FF.9030202@ru.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4613A4FF.9030202@ru.mvista.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Yes I have tested it on PPC, X86, X86_64, Mips targets.
> It works.

> >>+                           cap_t(p->nvcsw),
> >>+                           cap_t(p->nivcsw),

Nvcsw? W dn't s ncrptd dntfrs lk nvcsw n krnl. (:-)

						Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
