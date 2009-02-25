Return-Path: <linux-kernel-owner+w=401wt.eu-S1760106AbZBYHxw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760106AbZBYHxw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 02:53:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757764AbZBYHxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 02:53:39 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54866
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757426AbZBYHxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 02:53:39 -0500
Date: Tue, 24 Feb 2009 23:53:17 -0800 (PST)
Message-Id: <20090224.235317.10940015.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2009-02-23
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090223192617.GA3553@tuxdriver.com>
References: <20090223192617.GA3553@tuxdriver.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Mon, 23 Feb 2009 14:26:17 -0500

> Here are a couple of fixes, one for an oops and one for a warning.  Also
> included is a PCI ID addition.  These are intended for 2.6.29.

Pulled, thanks John.

> P.S.  This causes some conflicts with -next.  The ath9k conflict is
> simple.  The orinoco conflict involves moving some code from orinoco.c
> to orinoco/main.c in -next (where orinoco.c no longer exists).  I have
> included a "merge-test" branch in the wireless-next-2.6 tree to provide
> and example for the merge when you get to it.

Ok, I'll take care of that now, thanks John.
