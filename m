Return-Path: <linux-kernel-owner+w=401wt.eu-S1946410AbXBIM1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946410AbXBIM1q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 07:27:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946416AbXBIM1q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 07:27:46 -0500
Received: from hermes.domdv.de ([193.102.202.1]:1397 "EHLO hermes.domdv.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946410AbXBIM1p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 07:27:45 -0500
Message-ID: <45CC68BC.2040000@domdv.de>
Date: Fri, 09 Feb 2007 13:27:40 +0100
From: Andreas Steinmetz <ast@domdv.de>
User-Agent: Mail/News 1.5.0.7 (X11/20060915)
MIME-Version: 1.0
To: Alex Dubov <oakad@yahoo.com>
CC: Pierre Ossman <drzeus-mmc@drzeus.cx>, linux-kernel@vger.kernel.org
Subject: Re: [2.6.20] tifm_7xx1/mmc not working
References: <623185.69808.qm@web36711.mail.mud.yahoo.com>
In-Reply-To: <623185.69808.qm@web36711.mail.mud.yahoo.com>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Dubov wrote:
> I'm aware that there are some weird problems with a 2.6.20. I'm currently looking into it.
> 
> Besides, I wonder, are tifm and sdhci play nicely together? And then, we do know that suspend is
> totally broken in the older versions of the driver. So it may be desirable to make a test with
> sdhci unloaded and machine freshly rebooted (not resumed).
> 

I tried exactly as described (fresh cold boot, sdhci never loaded), but
the described problem remains. If there is anything I can do to help to
trace this problem let me know.

-- 
Andreas Steinmetz                       SPAMmers use robotrap@domdv.de
