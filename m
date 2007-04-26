Return-Path: <linux-kernel-owner+w=401wt.eu-S1031298AbXDZQKe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031298AbXDZQKe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 12:10:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031318AbXDZQKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 12:10:34 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:34932 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031298AbXDZQKc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 12:10:32 -0400
To: rjw@sisk.pl
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2: hang in atomic copy)
X-IlohaMail-Blah: penberg@cs.helsinki.fi
X-IlohaMail-Method: mail() [mem]
X-IlohaMail-Dummy: moo
X-Mailer: IlohaMail/0.8.12+pk-11 (On: iloha.cs.Helsinki.FI)
In-Reply-To: <200704261648.25189.rjw@sisk.pl>
Message-ID: <qlG9V8pP.1177603830.8836760.penberg@cs.helsinki.fi>
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
CC: "Pavel Machek" <pavel@ucw.cz>,
       "Dumitru Ciobarcianu" <Dumitru.Ciobarcianu@ines.ro>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Nigel Cunningham" <nigel@nigel.suspend2.net>,
       "Christian Hesse" <mail@earthworm.de>, "Nick Piggin" <npiggin@suse.de>,
       "Mike Galbraith" <efault@gmx.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Con Kolivas" <kernel@kolivas.org>,
       "suspend2-devel@lists.suspend2.net" 
	<suspend2-devel@lists.suspend2.net>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Arjan van de Ven" <arjan@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Date: Thu, 26 Apr 2007 19:10:30 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On 4/26/2007, "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> In principle, we could add suspend2 as an alternative (in analogy with the I/O
> schedulers, for example), but I think for this purpose it should be reviewed
> properly.

Yeah, this makes sense.

On 4/26/2007, "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> There also is a real problem with how it uses the LRU pages.  It _seems_ to
> work, but at least to me it seems to be potentially dangerous.

I am new to suspend2 so can you please explain what exactly is dangerous
about it?

                                     Pekka
