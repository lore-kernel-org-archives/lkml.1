Return-Path: <linux-kernel-owner+w=401wt.eu-S933069AbXCVPIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933069AbXCVPIW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 11:08:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933113AbXCVPIW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 11:08:22 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3710 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933069AbXCVPIV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 11:08:21 -0400
Date: Mon, 19 Mar 2007 19:55:11 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Marcus Better <marcus@better.se>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc4: suspend broken on Thinkpad R60
Message-ID: <20070319195510.GA3959@ucw.cz>
References: <etdl6q$ef6$1@sea.gmane.org> <etdqeo$vsa$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <etdqeo$vsa$1@sea.gmane.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > suspend (to RAM and disk) broke on my Thinkpad R60 (Core 2 Duo laptop)
> > somewhere between 2.6.20 and 2.6.21-rc3
> 
> I just tried -rc4, and it's still broken.

Try disabling hires timers and no_hz.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
