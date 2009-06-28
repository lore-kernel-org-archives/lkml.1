Return-Path: <linux-kernel-owner+w=401wt.eu-S1754778AbZF1Kf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778AbZF1Kf2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 06:35:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752030AbZF1KfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 06:35:18 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33355 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804AbZF1KfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 06:35:17 -0400
Date: Sun, 28 Jun 2009 12:05:21 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.31-rc1
Message-ID: <20090628100521.GA8673@ucw.cz>
References: <alpine.LFD.2.01.0906241656030.3605@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0906241656030.3605@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> On architectures: ARM, powerpc, mips, sh, x86 are the bulk of it. On ARM, 
> the bulk is new platforms (u300, freescale stmp, whatever), there seems to 
> be no end to crazy new arm platforms. On x86 (and at least some degree on 

HW vendors on arm seem to produce all the new, incompatible devices,
all the time :-(. Arm vendors seem to multiply, and compatibility
seems to be very low on their list of priorities... and it is only
getting worse. 
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
