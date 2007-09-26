Return-Path: <linux-kernel-owner+w=401wt.eu-S1755004AbXIZF6F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755004AbXIZF6F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 01:58:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753138AbXIZF5z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 01:57:55 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38868
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752745AbXIZF5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 01:57:54 -0400
Date: Tue, 25 Sep 2007 22:57:54 -0700 (PDT)
Message-Id: <20070925.225754.119290298.davem@davemloft.net>
To: marcel@holtmann.org
Cc: xiyou.wangcong@gmail.com, akpm@linux-foundation.org, 12o3l@tiscali.nl,
       linux-kernel@vger.kernel.org, bluez-devel@lists.sourceforge.net,
       maxk@qualcomm.com
Subject: Re: [-mm Patch] net/bluetooth/hidp/core.c: Make hidp_setup_input()
 return int
From: David Miller <davem@davemloft.net>
In-Reply-To: <1190672287.5133.138.camel@aeonflux.holtmann.net>
References: <20070924021716.9bfe7dfb.akpm@linux-foundation.org>
	<20070924113035.GE2442@hacking>
	<1190672287.5133.138.camel@aeonflux.holtmann.net>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcel Holtmann <marcel@holtmann.org>
Date: Tue, 25 Sep 2007 00:18:07 +0200

> Hi Wang,
> 
> > This patch:
> > - makes hidp_setup_input() return int to indicate errors;
> > - checks its return value to handle errors.
> > 
> > And this time it is against -rc7-mm1 tree.
> > 
> > Thanks to roel and Marcel Holtmann for comments.
> > 
> > Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
> 
> Signed-off-by: Marcel Holtmann <marcel@holtmann.org>

Applied, thanks.
