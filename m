Return-Path: <linux-kernel-owner+w=401wt.eu-S1753977AbZITHz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977AbZITHz2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 03:55:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753683AbZITHz2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 03:55:28 -0400
Received: from casper.infradead.org ([85.118.1.10]:55501 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646AbZITHz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 03:55:27 -0400
Date: Sun, 20 Sep 2009 09:52:39 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alok Kataria <akataria@vmware.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
       Greg KH <greg@kroah.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Paravirtualization on VMware's Platform [VMI].
Message-ID: <20090920095239.456ad6f2@infradead.org>
In-Reply-To: <20090920074247.GA5733@elte.hu>
References: <1253233028.19731.63.camel@ank32.eng.vmware.com>
	<20090919224430.GB9567@kroah.com>
	<1253419185.3253.21.camel@ank32.eng.vmware.com>
	<20090920074247.GA5733@elte.hu>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Sep 2009 09:42:47 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> If we were able to rip out all (or most) of paravirt from arch/x86 it 
> would be tempting for other technical reasons - but the patch above
> is well localized.

interesting question is if this would allow us to remove a few of the
paravirt hooks....


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
