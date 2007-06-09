Return-Path: <linux-kernel-owner+w=401wt.eu-S1759577AbXFIT14@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759577AbXFIT14 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 15:27:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758587AbXFIT1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 15:27:47 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:33195 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759251AbXFIT1q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 15:27:46 -0400
Date: Sat, 9 Jun 2007 21:27:03 +0200
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org
Cc: ipw2100-admin@linux.intel.com
Subject: ipw3945 driver in recent -mm kernels
Message-ID: <20070609192703.GA6410@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I tried to use `subj`, but hit few problems:

There's no maintainers entry. Should

 James P. Ketrenos <ipw2100-admin@linux.intel.com> 

be listed as a maintainer?

Kconfig mentions...

          See <file:Documentation/networking/README.iwlwifi> for
          information on the capabilities currently enabled in this
          driver and for tips for debugging issues and problems.

...but that file does not exist.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
