Return-Path: <linux-kernel-owner+w=401wt.eu-S966359AbXHaVl1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966359AbXHaVl1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 17:41:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965855AbXHaVlQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 17:41:16 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57409
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S965747AbXHaVlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 17:41:15 -0400
Date: Fri, 31 Aug 2007 14:41:15 -0700 (PDT)
Message-Id: <20070831.144115.48807246.davem@davemloft.net>
To: alan@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       linux-serial@vger.kernel.org
Subject: Re: Heads Up: Next Batch Of Serial/TTY Changes
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070831221105.2fce9023@the-village.bc.nu>
References: <20070831221105.2fce9023@the-village.bc.nu>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Date: Fri, 31 Aug 2007 22:11:05 +0100

> Firstly some architecture maintainers still haven't updated their
> platform for arbitary tty speeds. The kernel is going to start whining
> and issuing warnings on your platform if you don't keep up with the
> programme (its been 6 months).

I took a look at this for sparc and I'm currently balking the same way
you did :-) The current bit usage on sparc just don't work properly
for what you're trying to do.
