Return-Path: <linux-kernel-owner+w=401wt.eu-S1751440AbXBEKa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751440AbXBEKa0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 05:30:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751434AbXBEKaZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 05:30:25 -0500
Received: from main.gmane.org ([80.91.229.2]:51531 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751440AbXBEKaZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 05:30:25 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Benny Amorsen <benny+usenet@amorsen.dk>
Subject: Re: smp and irq conflict
Date: 05 Feb 2007 11:33:23 +0100
Message-ID: <m3zm7suc5o.fsf@ursa.amorsen.dk>
References: <45BE4003005C2845@vsmtp2.tin.it> <45C35024.8090907@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: 10.8.185.213.dk-amb.res.sta.perspektivbredband.net
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.4
Cc: linux-smp@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "BD" == Bill Davidsen <davidsen@tmr.com> writes:

BD> You may be able to move one board to another slot, but looking at
BD> the bandwidth I suspect you may need a server motherboard with
BD> multiple busses, preferably running at 66MHz 64bit. I don't think
BD> this is a interrupt problem, but you can just try capture on two
BD> channels which share an interrupt, like bttv0 and bttv7 to verify
BD> that.

66MHz 64bit isn't much fun when the capture cards are 33MHz 32bit.


/Benny


