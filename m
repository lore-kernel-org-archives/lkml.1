Return-Path: <linux-kernel-owner+w=401wt.eu-S1761658AbYCWMag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761658AbYCWMag (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 08:30:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759417AbYCWMa2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 08:30:28 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51728
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1759359AbYCWMa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 08:30:27 -0400
Date: Sun, 23 Mar 2008 05:30:37 -0700 (PDT)
Message-Id: <20080323.053037.144236584.davem@davemloft.net>
To: jirislaby@gmail.com
Cc: viro@ZenIV.linux.org.uk, joe@perches.com, mingo@elte.hu,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 109/148] include/asm-x86/serial.h: checkpatch cleanups
 - formatting only
From: David Miller <davem@davemloft.net>
In-Reply-To: <47E64BF7.4070808@gmail.com>
References: <47E647AC.1060906@gmail.com>
	<20080323.051929.267232495.davem@davemloft.net>
	<47E64BF7.4070808@gmail.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jirislaby@gmail.com>
Date: Sun, 23 Mar 2008 13:24:23 +0100

> On 03/23/2008 01:19 PM, David Miller wrote:
> > There are mountains of more useful stuff to be working on (much of it
> > automated, but unlike checkpatch work doesn't result in crap) rather
> > than 148 patches of checkpatch vomit.
> > 
> > Fixing sparse warnings properly fixes real issues, whereas fixing
> > checkpatch stuff creates garbage 9 times out of 10.
> 
> Yes, I agree with you in this.
> 
> What I don't agree with is that it's useless. It may help track down some issues 
> in yet prepared patch (it's checkpatch, not checkcode and it should be used in 
> that manner).

I strongly disagree still.

Half the warnings I get when I have run checkpatch on things I've
written were crap.

It's an automaton, and that's why people like it.  It tells you
exactly what to do, and people like to be able to turn their brains
off like that.
