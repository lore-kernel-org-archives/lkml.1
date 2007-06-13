Return-Path: <linux-kernel-owner+w=401wt.eu-S1757718AbXFMKw5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757718AbXFMKw5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 06:52:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756591AbXFMKwu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 06:52:50 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:56463 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755315AbXFMKwt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 06:52:49 -0400
Date: Wed, 13 Jun 2007 12:52:43 +0200
From: Pavel Machek <pavel@ucw.cz>
To: James Ketrenos <jketreno@linux.intel.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org,
       Zhu Yi <yi.zhu@intel.com>
Subject: Re: ipw3945 driver in recent -mm kernels
Message-ID: <20070613105243.GA15368@elf.ucw.cz>
References: <20070609192703.GA6410@elf.ucw.cz> <20070609215712.GA13678@elf.ucw.cz> <466DA14D.6080309@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <466DA14D.6080309@linux.intel.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Forgot to include changes outside of drivers/net/wireless/mac80211/iwlwifi/
> 
> Zhu Yi is the maintainer for the iwlwifi driver (Cc: on this email)

Thanks.

> >>
> >> be listed as a maintainer?
> >>
> >> Kconfig mentions...
> >>
> >>           See <file:Documentation/networking/README.iwlwifi> for
> >>           information on the capabilities currently enabled in this
> >>           driver and for tips for debugging issues and problems.
> 
> We'll remove that from the Kconfig until we get the document updated
> to reflect the current status.

Actually, It is probably better to just include the docs.

(I'll test the patch now).
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
