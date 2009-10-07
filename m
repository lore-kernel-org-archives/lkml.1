Return-Path: <linux-kernel-owner+w=401wt.eu-S1758593AbZJGGjJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758593AbZJGGjJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 02:39:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756415AbZJGGjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 02:39:08 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40024
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758224AbZJGGjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 02:39:07 -0400
Date: Tue, 06 Oct 2009 23:39:01 -0700 (PDT)
Message-Id: <20091006.233901.192206610.davem@davemloft.net>
To: tilman@imap.cc
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, hjlipp@web.de,
       isdn@linux-pingi.de, keil@b1-systems.de,
       isdn4linux@listserv.isdn4linux.de, i4ldeveloper@listserv.isdn4linux.de
Subject: Re: [PATCH 00/11] Gigaset driver patches for 2.6.32 (v3)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091006-patch-gigaset-00.tilman@imap.cc>
References: <20091006-patch-gigaset-00.tilman@imap.cc>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tilman Schmidt <tilman@imap.cc>
Date: Wed,  7 Oct 2009 00:18:21 +0200 (CEST)

> This is the third release of the series of patches for the Gigaset
> drivers I first submitted on 2009-09-06. I have dropped the first patch
> "gigaset: really fix chars_in_buffer" because it has now been merged
> through the tty tree, and folded into the last one the fixes I posted on
> 2009-09-25 and 2009-10-01. Apart from that, the series is unchanged from
> the second submission on 2009-09-19. It would be great if this could
> still make it into release 2.6.32 as one more step on the way to get rid
> of the deprecated ISDN4Linux subsystem.

I applied patches 1-8 to net-2.6, merged net-2.6 into net-next-2.6,
then added patches 9-11 into net-next-2.6

Thanks!
