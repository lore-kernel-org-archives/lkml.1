Return-Path: <linux-kernel-owner+w=401wt.eu-S1755391AbYJGP0J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755391AbYJGP0J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 11:26:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753035AbYJGPZ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 11:25:56 -0400
Received: from ftp.linux-mips.org ([213.58.128.207]:44518 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752842AbYJGPZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 11:25:56 -0400
Date: Tue, 7 Oct 2008 16:25:53 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Jason Vas Dias <jason.vas.dias@gmail.com>
Subject: Re: [PATCH] x86: SB450: skip IRQ0 override if it is not routed to
 INT2 of IOAPIC
In-Reply-To: <20081006221122.GC22097@alberich.amd.com>
Message-ID: <alpine.LFD.1.10.0810071625030.32549@ftp.linux-mips.org>
References: <20081005183603.GA3263@amd.corenet.prv> <200810060029.42471.rjw@sisk.pl> <20081006062235.GA2808@amd.corenet.prv> <200810061159.30103.rjw@sisk.pl> <alpine.LFD.2.00.0810060749570.3208@nehalem.linux-foundation.org> <20081006150055.GA16930@elte.hu>
 <alpine.LFD.1.10.0810061815060.10470@ftp.linux-mips.org> <87tzbpmocm.fsf@basil.nowhere.org> <alpine.LFD.1.10.0810062227100.10470@ftp.linux-mips.org> <20081006221122.GC22097@alberich.amd.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Oct 2008, Andreas Herrmann wrote:

> Following patch is almost untested -- especially I didn't get my
> hands on one of the HP Laptops with broken DSDT.

 Thanks a lot for the fix even though I cannot test it!

  Maciej
