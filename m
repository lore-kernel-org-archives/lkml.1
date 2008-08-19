Return-Path: <linux-kernel-owner+w=401wt.eu-S1754033AbYHSEQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033AbYHSEQp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 00:16:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751110AbYHSEQe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 00:16:34 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57157
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751107AbYHSEQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 00:16:33 -0400
Date: Mon, 18 Aug 2008 21:16:32 -0700 (PDT)
Message-Id: <20080818.211632.251536898.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2008-08-18
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080818151551.GA5524@tuxdriver.com>
References: <20080817185605.GC30679@tuxdriver.com>
	<20080817.151251.204370966.davem@davemloft.net>
	<20080818151551.GA5524@tuxdriver.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Mon, 18 Aug 2008 11:15:51 -0400

> (Revision 2, commit references in changelogs augmented w/ subject text.)
> 
> Here is the latest round of wireless fixes for 2.6.27.  The silliest one
> is the one from Adrian Bunk, which applies the gcc-related fix to ath9k
> again because there were two identical pieces of code to fix -- I guess
> I didn't get the joke *facepalm*...
> 
> I don't think there is anything else remarkable, although I think we fix
> a couple of the current regressions on LKML.

Pulled thanks John.

Assuming nothing shows up in my build testing I'll push this out
to kernel.org shortly.

Thanks again!
