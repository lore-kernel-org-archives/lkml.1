Return-Path: <linux-kernel-owner+w=401wt.eu-S1946425AbXBQGpV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946425AbXBQGpV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 01:45:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946426AbXBQGpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 01:45:21 -0500
Received: from mx1.redhat.com ([66.187.233.31]:34501 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946425AbXBQGpU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 01:45:20 -0500
To: davids@webmaster.com
Cc: <jas6180@gmail.com>,
       "Linux-Kernel\@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: GPL vs non-GPL device drivers
References: <MDEHLPKNGKAHNMBLJOLKMEIMBKAC.davids@webmaster.com>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Sat, 17 Feb 2007 04:44:36 -0200
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKMEIMBKAC.davids@webmaster.com> (David Schwartz's message of "Fri\, 16 Feb 2007 18\:42\:38 -0800")
Message-ID: <orejops2p7.fsf@free.oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.93 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 17, 2007, "David Schwartz" <davids@webmaster.com> wrote:

> Not so. See any of the numerous cases that explain that you cannot own a
> function using copyright. They are saying that because V J did X, he *MUST*
> be taking their code because there is no other practical way to *do* X. This
> is precisely what copyright *DOES* *NOT* *LET* *YOU* *DO*.

So, since there's no other way to do Yesterday, exactly as performed
by the Beatles in the 1965 album Help!, I'm free to copy it, perform
it, create derived versions thereof and perform them, without paying
royalties to the current copyright holders?

> The fact that they are claiming rights that are impossible with copyright
> and inconsistent with its logic. Copyright covers the one way you chose to
> do something out of the many possible ways to do it. To argue "you must have
> taken my code because you were able to *DO* X" is arguing you own every
> practical way to do X. This is what software patents do, but this is beyond
> the scope of copyright.

You're on to something, but I think you're taking it too far.

One could always create a clean-room implementation of kernel headers
and use them to build a module that presumably wouldn't be a derived
work, as long as the binary is indeed created using these clean-room
headers.  But who does that, considering how quickly kernel headers
change, and that if you build the object code using the actual kernel
headers, then the binary is likely to be a derived work of the kernel,
even if the sources still aren't?

#include <std/IANAL.h>

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
