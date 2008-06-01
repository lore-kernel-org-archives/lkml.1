Return-Path: <linux-kernel-owner+w=401wt.eu-S1755323AbYFAQRp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323AbYFAQRp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 12:17:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755195AbYFAQRb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 12:17:31 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1766 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752344AbYFAQRa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 12:17:30 -0400
Date: Sun, 1 Jun 2008 18:17:16 +0200
From: Pavel Machek <pavel@ucw.cz>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       David Miller <davem@davemloft.net>,
       James.Bottomley@HansenPartnership.com,
       ksummit-2008-discuss@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [Ksummit-2008-discuss] RFC: Moving firmware blobs out of the kernel.
Message-ID: <20080601161715.GB5555@ucw.cz>
References: <1212077700.26088.83.camel@shinybook.infradead.org> <20080529164745.GA21763@kroah.com> <483F1232.4010003@linux.intel.com> <20080529.140919.160813310.davem@davemloft.net> <483F1C17.8040207@linux.intel.com> <1212102258.20303.6.camel@shinybook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1212102258.20303.6.camel@shinybook.infradead.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> The firmware is an independent and separate work in itself. Section 2 of
> the GPL talks about such sections of the work, explicitly. The only way
> to excuse what we're doing at the moment is to call it 'mere
> aggregation' -- an exception which was intended to handle stuff like the
> 'freeware' CDs on the covers of magazines, distributing a bunch of
> unrelated software. Not a coherent work combining software from
> different sources into a single entity which works closely together as
> one, and where one part is useless without the other.

Wait a moment, haven't you just described linux distribution?

I mean, if aggregation clause does not work for firmware in kernel,
why would it work for packages in distro?

(Actually, seeing some distro EULAs, I wished GPL infected whole
distro so that I'd not have to read the stupid EULA.)

> There are people who own copyright on firmware who refuse to put it into
> the Linux source tree, because their lawyers don't believe the 'mere
> aggregation' line, and believe that including it in the kernel source in
> any form would require them to license it under the GPL.

They can release the firmware under BSD 3-clause, and we can include
it in kernel, then.... right? (Or into linux-firmware or into whatever
package that comes handy).

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
