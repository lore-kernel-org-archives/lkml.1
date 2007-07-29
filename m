Return-Path: <linux-kernel-owner+w=401wt.eu-S1760625AbXG2HSw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760625AbXG2HSw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 03:18:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759070AbXG2HSn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 03:18:43 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39383
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1759051AbXG2HSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 03:18:42 -0400
Date: Sun, 29 Jul 2007 00:18:37 -0700 (PDT)
Message-Id: <20070729.001837.104033253.davem@davemloft.net>
To: marcel@holtmann.org
Cc: viro@ftp.linux.org.uk, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH 4/4] l2cap: don't mangle cmd.len
From: David Miller <davem@davemloft.net>
In-Reply-To: <1185547286.13228.18.camel@violet>
References: <E1IEPNw-0005TA-89@ZenIV.linux.org.uk>
	<1185547286.13228.18.camel@violet>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcel Holtmann <marcel@holtmann.org>
Date: Fri, 27 Jul 2007 16:41:26 +0200

> > Since nobody uses it after we convert it to host-endian,
> > no need to do that at all.  At that point l2cap is endian-clean.
> > 
> > Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> 
> Signed-off-by: Marcel Holtmann <marcel@holtmann.org>

Also applied, thanks a lot.
