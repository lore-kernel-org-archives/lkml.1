Return-Path: <linux-kernel-owner+w=401wt.eu-S933345AbXCWTWf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933345AbXCWTWf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 15:22:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933592AbXCWTWf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 15:22:35 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38919
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S933345AbXCWTWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 15:22:34 -0400
Date: Fri, 23 Mar 2007 12:22:32 -0700 (PDT)
Message-Id: <20070323.122232.85421062.davem@davemloft.net>
To: alan@lxorguk.ukuu.org.uk
Cc: randy.dunlap@oracle.com, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, kyle@canonical.com
Subject: Re: HPA patches
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070323200819.4e734f4f@lxorguk.ukuu.org.uk>
References: <20070323191321.5d00887a@lxorguk.ukuu.org.uk>
	<20070323112411.f6a8a762.randy.dunlap@oracle.com>
	<20070323200819.4e734f4f@lxorguk.ukuu.org.uk>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Date: Fri, 23 Mar 2007 20:08:19 +0000

> u64 is always unsigned long long (and its debug anyway)

It's plain "unsigned long" on sparc64 and some other 64-bit platforms.
