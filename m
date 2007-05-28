Return-Path: <linux-kernel-owner+w=401wt.eu-S1762126AbXE1Jvj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762126AbXE1Jvj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 05:51:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751978AbXE1Jvc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 05:51:32 -0400
Received: from main.gmane.org ([80.91.229.2]:59975 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751866AbXE1Jvc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 05:51:32 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Benny Amorsen <benny+usenet@amorsen.dk>
Subject: Re: 2.6.21.1 - 97% wait time on IDE operations
Date: 28 May 2007 11:51:14 +0200
Message-ID: <m31wh18eel.fsf@ursa.amorsen.dk>
References: <200705261505.38109@gj-laptop> <200705261746.01568@gj-laptop> <2c0942db0705260907g4e37d4avcc652d2b7368edd5@mail.gmail.com> <200705271222.30169@gj-laptop> <20070527130228.3731ff4d@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: 10.8.185.213.dk-amb.res.sta.perspektivbredband.net
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "AC" == Alan Cox <alan@lxorguk.ukuu.org.uk> writes:

AC> Provided they don't get within about 5-10% of full a lot of the
AC> time Unix file systems generally don't

That's a big if right there. For servers it isn't a problem, few
people can get capacity right to withing 10%, so you never let a
server run full. Desktops/laptops on the other hand spend most of
their lives between 80% and 100%.


/Benny


