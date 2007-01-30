Return-Path: <linux-kernel-owner+w=401wt.eu-S1751959AbXA3WT4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751959AbXA3WT4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 17:19:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751977AbXA3WT4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 17:19:56 -0500
Received: from main.gmane.org ([80.91.229.2]:43743 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751971AbXA3WTz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 17:19:55 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Matthieu CASTET <castet.matthieu@free.fr>
Subject: Re: Free Linux Driver Development!
Date: Tue, 30 Jan 2007 22:19:32 +0000 (UTC)
Message-ID: <loom.20070130T231421-484@post.gmane.org>
References: <20070130012904.GA9617@kroah.com> <ada8xfks90x.fsf@cisco.com>	<20070130191020.GF20642@kroah.com> <adaodogqpmx.fsf@cisco.com> <45BFA087.6020905@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 81.57.151.96 (Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.9) Gecko/20061219 Iceape/1.0.7 (Debian-1.0.7-2))
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik <jeff <at> garzik.org> writes:

> > And I seem to recall there's more SATA chipset documentation than Jeff
> > Garzik has time to implement support for.
> 
> I seriously doubt you can come up with even a single concrete example here.
> 
> Regardless, libata has 55+ drivers and counting, all for the price of 
> documentation and hardware.  Another quite strong counter example.
> 
On another side, some PATA drivers are incomplete or missing.

When we switch to PATA and drop old ide stack, what will happen ?
Will all driver be ported and full-feature, or some will be obsoleted ?


Matthieu

