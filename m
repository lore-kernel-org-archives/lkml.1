Return-Path: <linux-kernel-owner+w=401wt.eu-S1754559AbXD2EBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559AbXD2EBk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 00:01:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754560AbXD2EBj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 00:01:39 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47764
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754557AbXD2EBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 00:01:38 -0400
Date: Sat, 28 Apr 2007 21:01:47 -0700 (PDT)
Message-Id: <20070428.210147.111207684.davem@davemloft.net>
To: mark@mtfhpc.demon.co.uk
Cc: wli@holomorphy.com, linux-kernel@vger.kernel.org,
       sparclinux@vger.kernel.org, linux-serial@vger.kernel.org,
       jengelh@linux01.gwdg.de
Subject: Re: [TESTING NEEDED] drivers/serial/sunzilog: Interrupt enable
 before ISR handler installed
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.61.0704281529090.8157@mtfhpc.demon.co.uk>
References: <Pine.LNX.4.61.0704281529090.8157@mtfhpc.demon.co.uk>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Your patch is extremely mangled, please try to email it to yourself
and apply it if in doubt.

Furthermore, the comment your patch adds is unnecessary.  That kind of
text belongs in the changelog comment, not the code.  The changelog is
also where you'll get credit for your change.

There is no reason to play Napoleon in the source files any more now
that we have proper source control and history all these years. :-)

Please fix all of this up and resubmit, thank you.
