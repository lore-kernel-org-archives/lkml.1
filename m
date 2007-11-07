Return-Path: <linux-kernel-owner+w=401wt.eu-S1757086AbXKGJ3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757086AbXKGJ3q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 04:29:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757791AbXKGJ3Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 04:29:25 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45357
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1758112AbXKGJ3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 04:29:24 -0500
Date: Wed, 07 Nov 2007 01:29:24 -0800 (PST)
Message-Id: <20071107.012924.246355578.davem@davemloft.net>
To: alan@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] tty - fix tty network driver interactions with
 TCGET/TCSET calls
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071102160039.55df8c26@the-village.bc.nu>
References: <20071102160039.55df8c26@the-village.bc.nu>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Date: Fri, 2 Nov 2007 16:00:39 +0000

> From: Dave Miller <davem@davemloft.net>
> 
> And to go with it Dave's type checking x86 termios headers. I've updated these as the original sent by Dave had some wrong types in it.
> 
> Signed-off-by: Alan Cox <alan@redhat.com>

Also applied, thanks a lot Alan.
