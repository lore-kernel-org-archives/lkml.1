Return-Path: <linux-kernel-owner+w=401wt.eu-S1754167AbYIQOPT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167AbYIQOPT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 10:15:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752352AbYIQOPE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 10:15:04 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:57398 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752266AbYIQOPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 10:15:03 -0400
X-Greylist: delayed 3060 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Sep 2008 10:15:01 EDT
Date: Wed, 17 Sep 2008 09:23:07 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Carlos Corbacho <carlos@strangeworlds.co.uk>,
       Adel Gadllah <adel.gadllah@gmail.com>,
       wireless <linux-wireless@vger.kernel.org>, bcm43xx-dev@lists.berlios.de,
       Michael Buesch <mb@bu3sch.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Regression in 2.6.27-rcX caused by commit
	bc19d6e0b74ef03a3baf035412c95192b54dfc6f
Message-ID: <20080917132305.GA5407@tuxdriver.com>
References: <48CFC03A.8020708@lwfinger.net> <200809161742.15527.mb@bu3sch.de> <48CFE820.7010305@lwfinger.net> <200809162018.28548.carlos@strangeworlds.co.uk> <48D0095B.40403@lwfinger.net> <20080916233240.GA18574@srcf.ucam.org> <20080917023334.GA1187@khazad-dum.debian.net> <48D070DC.80007@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48D070DC.80007@lwfinger.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-Score: -1.4 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2008 at 09:52:12PM -0500, Larry Finger wrote:

> I admit that I never tested any of the RFKILL patches as they went in.
> One of the reasons is that the development process seemed rather
> untidy to an outsider, and I wasn't sure that any of the code would
> ever be in the kernel. As such, it snuck up on me. I'll not let that
> happen again. After the reversion, I will again test any suggested
> code changes, but do not expect me to work out any of the changes. I
> have enough to do.

FWIW, Henrique has been very persistant with driving rfkill.  He has
posted and reposted his patch series many times.  I'm sorry that it
snuck-up on you but it was on the list for quite a while.

John
-- 
John W. Linville
linville@tuxdriver.com
