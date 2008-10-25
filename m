Return-Path: <linux-kernel-owner+w=401wt.eu-S1753084AbYJYKF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753084AbYJYKF2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 06:05:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751556AbYJYKFQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 06:05:16 -0400
Received: from ioctl.codeblau.de ([80.190.240.67]:45875 "EHLO codeblau.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751147AbYJYKFP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 06:05:15 -0400
Date: Sat, 25 Oct 2008 12:05:12 +0200
From: Felix von Leitner <felix-linuxkernel@fefe.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: Linux Kernel Mailing list <linux-kernel@vger.kernel.org>
Subject: Re: MCEs
Message-ID: <20081025100512.GA27457@codeblau.de>
References: <20081024124502.GA9425@codeblau.de> <87r66598eq.fsf@basil.nowhere.org> <20081024230748.GA21365@codeblau.de> <20081025070013.GJ27492@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081025070013.GJ27492@one.firstfloor.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thus spake Andi Kleen (andi@firstfloor.org):
> > Using an older kernel I get actual MCE messages that I can write down
> > and decode using mcelog.
> You mean when you switch back to the old kernel it's recoverable
> and then switch to the new kernel it is not?

No it's not recoverable but I get the error messages and can write them
down.  Previously I just got the stack dump.

> > panic obscures them by scrolling them out of my 80x25 screen).
> Panic should be one line, unless you're bitten by the 2.6.27 
> smp_call_function in panic bug (see 
> http://bugzilla.kernel.org/show_bug.cgi?id=11569)

That's exactly what happened.

Felix
