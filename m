Return-Path: <linux-kernel-owner+w=401wt.eu-S1422843AbXBUTir@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422843AbXBUTir (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 14:38:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422840AbXBUTir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 14:38:47 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:58685 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1422838AbXBUTiq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 14:38:46 -0500
Date: Wed, 21 Feb 2007 20:38:36 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Stephen Hemminger <shemminger@osdl.org>
Cc: James Ketrenos <jketreno@linux.intel.com>, netdev@vger.kernel.org,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       ipw3945-devel@lists.sourceforge.net
Subject: Re: iwlwifi warnings
Message-ID: <20070221193836.GC3732@elf.ucw.cz>
References: <45CCE3CA.4050904@linux.intel.com> <20070213181313.GA5350@ucw.cz> <45D254C6.7050401@linux.intel.com> <20070219224432.GD21199@elf.ucw.cz> <45DBE559.8080903@osdl.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45DBE559.8080903@osdl.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> BUilding with sparse shows lots of warnings.

You seem to be the lucky one, able to actually compile the
beast. Could you run diff against vanilla and post it somewhere?

"Normal" installation procedure has too many steps in my eyes, and
combined git tree is not available, so I was waiting for merge at
least into -wirelessdev tree.
							Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
