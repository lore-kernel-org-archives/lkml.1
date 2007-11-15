Return-Path: <linux-kernel-owner+w=401wt.eu-S1763106AbXKOBeI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763106AbXKOBeI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 20:34:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755973AbXKOBdz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 20:33:55 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43780
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754892AbXKOBdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 20:33:55 -0500
Date: Wed, 14 Nov 2007 17:33:54 -0800 (PST)
Message-Id: <20071114.173354.218572335.davem@davemloft.net>
To: russ@elegant-software.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: OT: Does Linux have any "Perfect Code"
From: David Miller <davem@davemloft.net>
In-Reply-To: <c9d133bdb3481fbc01a572d948049f5e@elegant-software.com>
References: <c9d133bdb3481fbc01a572d948049f5e@elegant-software.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Russell Leighton <russ@elegant-software.com>
Date: Wed, 14 Nov 2007 20:21:04 -0500

> > At the risk of being egocentric, the cyclic subsystem (which is
> > executed at least 100 times per second on every Solaris system)
> > had its last substantial fix over six years ago, and its last fix
> > of any flavor over three years ago:

Yeah, if you develop at the glacial pace Solaris does, don't add any
features to cyclics or work on scalability improvment, sure it can be
bug free and untouched for 6 years.

I think all of this talk of perfect code is just trolling by the
Solaris folks.
