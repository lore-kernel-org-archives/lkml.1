Return-Path: <linux-kernel-owner+w=401wt.eu-S1752701AbYDNJhW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701AbYDNJhW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 05:37:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751248AbYDNJhJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 05:37:09 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59004
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750755AbYDNJhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 05:37:08 -0400
Date: Mon, 14 Apr 2008 02:37:05 -0700 (PDT)
Message-Id: <20080414.023705.205865013.davem@davemloft.net>
To: viro@ZenIV.linux.org.uk
Cc: jakub@redhat.com, mingo@elte.hu, randy.dunlap@oracle.com,
       sfr@canb.auug.org.au, mingo@redhat.com, tglx@linutronix.de,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: Tree for April 10 (arch/x86)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080414093038.GA9785@ZenIV.linux.org.uk>
References: <20080414083440.GD19865@elte.hu>
	<20080414084320.GE23259@devserv.devel.redhat.com>
	<20080414093038.GA9785@ZenIV.linux.org.uk>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@ZenIV.linux.org.uk>
Date: Mon, 14 Apr 2008 10:30:38 +0100

> BTW, ISTR FreeBSD folks carrying gcc patches in their tree for something
> with similar purpose - project-specific format modifiers/specifiers.
> No idea how hard it would be to generalize, though - never looked at
> those in details...

You might be thinking of:

	http://www.stack.nl/~marcolz/FreeBSD/gcc-printf.patch
