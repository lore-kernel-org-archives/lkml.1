Return-Path: <linux-kernel-owner+w=401wt.eu-S1757373AbXG1UT5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757373AbXG1UT5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 16:19:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755442AbXG1UTu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 16:19:50 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:53524 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755529AbXG1UTt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 16:19:49 -0400
Date: Sat, 28 Jul 2007 22:21:05 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Meelis Roos <mroos@linux.ee>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Richard Henderson <rth@twiddle.net>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Jay Estabrook <jay.estabrook@hp.com>
Subject: Re: alpha compile failure (srm_printk)
Message-ID: <20070728202105.GC25619@uranus.ravnborg.org>
References: <Pine.SOC.4.64.0706041419470.7370@math> <20070605231712.ff1df46f.akpm@linux-foundation.org> <Pine.SOC.4.64.0707281950340.20474@math.ut.ee> <20070728200450.GA25619@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070728200450.GA25619@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 28, 2007 at 10:04:50PM +0200, Sam Ravnborg wrote:
> 
> The fix is to split kasprintf out to a separate file to
> avoid pulling in more stuff than necessary.
I just sent a patch doing this and I assume you take care of the alpha changes.

Thanks,
	Sam
