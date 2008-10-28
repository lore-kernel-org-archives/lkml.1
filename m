Return-Path: <linux-kernel-owner+w=401wt.eu-S1754550AbYJ1SBB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550AbYJ1SBB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 14:01:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753302AbYJ1SAr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 14:00:47 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48365
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752312AbYJ1SAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 14:00:46 -0400
Date: Tue, 28 Oct 2008 11:00:24 -0700 (PDT)
Message-Id: <20081028.110024.197492570.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2008-10-27
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081027220049.GI20389@tuxdriver.com>
References: <20081027220049.GI20389@tuxdriver.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Mon, 27 Oct 2008 18:00:49 -0400

> Another round of fixes intended for 2.6.28 (got it right this time!)...
> 
> "p54: fix misbehavings when firmware can't be found" is a little big,
> but it fixes a double free of an IRQ (bug 11782). "ath5k: Reset key
> cache on interface up, thus fixing resume" is a little sizable too, but
> it moves some code intelligently to fix a regression we introduce on
> resume.  The other stuff is cleanups and a kernel-doc fix, as well as an
> initialization fix for rfkill.
> 
> Please let me know if there are problems!

Looks good, pulled, thanks a lot John.
