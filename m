Return-Path: <linux-kernel-owner+w=401wt.eu-S1761467AbYCWMT1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761467AbYCWMT1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 08:19:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755931AbYCWMTR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 08:19:17 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35257
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754379AbYCWMTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 08:19:17 -0400
Date: Sun, 23 Mar 2008 05:19:29 -0700 (PDT)
Message-Id: <20080323.051929.267232495.davem@davemloft.net>
To: jirislaby@gmail.com
Cc: viro@ZenIV.linux.org.uk, joe@perches.com, mingo@elte.hu,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 109/148] include/asm-x86/serial.h: checkpatch cleanups
 - formatting only
From: David Miller <davem@davemloft.net>
In-Reply-To: <47E647AC.1060906@gmail.com>
References: <20080323085210.GE10722@ZenIV.linux.org.uk>
	<20080323.032013.79276201.davem@davemloft.net>
	<47E647AC.1060906@gmail.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jirislaby@gmail.com>
Date: Sun, 23 Mar 2008 13:06:04 +0100

> On 03/23/2008 11:20 AM, David Miller wrote:
> > From: Al Viro <viro@ZenIV.linux.org.uk>
> > Date: Sun, 23 Mar 2008 08:52:10 +0000
> > 
> >> On Sun, Mar 23, 2008 at 01:03:24AM -0700, Joe Perches wrote:
> >>> Signed-off-by: Joe Perches <joe@perches.com>
> >> An obvious corollary to this highly inspired series of patches:
> > 
> > Acked-by: David S. Miller <davem@davemloft.net>
> > 
> > I totally agree, checkpatch is just shit.
> 
> I disagree. It's just misuse in this case (like using Lindent on whole tree).

Unlike sparse, this thing encourages the kind of behavior seen here.

And even worse it becomes monkey see monkey do.

There are mountains of more useful stuff to be working on (much of it
automated, but unlike checkpatch work doesn't result in crap) rather
than 148 patches of checkpatch vomit.

Fixing sparse warnings properly fixes real issues, whereas fixing
checkpatch stuff creates garbage 9 times out of 10.
