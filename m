Return-Path: <linux-kernel-owner+w=401wt.eu-S1765893AbXJRWsi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765893AbXJRWsi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 18:48:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760311AbXJRWsb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 18:48:31 -0400
Received: from tac.ki.iif.hu ([193.6.222.43]:36092 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753668AbXJRWsa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 18:48:30 -0400
From: Ferenc Wagner <wferi@niif.hu>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: RocketPort Linux driver errors on module reload
References: <bububu786234897832@pripojeni.net> <87k5pozgb5.fsf@tac.ki.iif.hu>
	<4713BAD0.9020606@gmail.com> <87myujsdpr.fsf@szonett.ki.iif.hu>
	<4af2d03a0710161419n3727dbfev10b1319599d30b49@mail.gmail.com>
	<87ve94ccnl.fsf@tac.ki.iif.hu> <4717D958.8030900@gmail.com>
Date: Fri, 19 Oct 2007 00:48:28 +0200
In-Reply-To: <4717D958.8030900@gmail.com> (Jiri Slaby's message of "Fri, 19
	Oct 2007 00:08:24 +0200")
Message-ID: <87r6jsca4j.fsf@tac.ki.iif.hu>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby <jirislaby@gmail.com> writes:

> I meant the creating of a git repository with only the module would be the
> easiest possible and most comfortable way for you :). Otherwise I can post you a
> patch serie.

We can go either way, as you prefer.
 
> On 10/18/2007 11:53 PM, Ferenc Wagner wrote:
> 
>> I expected an improper way to have some disadvantages at least. :)
>
> Yes, if you have pci hotpluggable motherboard :). Pci probing (the new method)
> allows you adding/probing pci devices on the fly, not only when the module is
> loading.

Thanks for the explanation.  Maybe one day the E15k-s in the basement
will make pretty good serial port concentrators.

> I did such switches in drivers several times yet, but I can't assure you, that I
> won't make any mistake, but this driver seems not to need too many changes.
> Maybe functionality regressions would occur rather than instability of system.

All right.

> Anyway I would rather wait for the changes from comtrol to not break their
> upcoming patches (if they post them in some short term) and then do these changes.

Ah, I didn't know you were in contact with them.  Till now I only got
a notice that my request had been forwarded to another continent with
the Linux developer. :)  Sure, let's wait for the answer.
-- 
Regards,
Feri.
