Return-Path: <linux-kernel-owner+w=401wt.eu-S966987AbXG3QfD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966987AbXG3QfD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 12:35:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966740AbXG3QeT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 12:34:19 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:29267 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966475AbXG3QeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 12:34:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=P7DlfsFosF/adXT5ZbLoP0ZoL5tIEBRxbNBPNel32ACc7X10TyzNKSpcIJ3hm7JUA3lUsc2w7Qba3b5VpmXdsyYp2CtuXHNv3mC79tAG+fN1s6AhIbDgIAdac3j8JCrNxujOAgSw3i6yqIVeL3IdFu7WrXLxfvWl88WRSHZqaTs=
Message-ID: <46AE12FF.3030805@googlemail.com>
Date: Mon, 30 Jul 2007 18:34:07 +0200
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-usb-devel@lists.sourceforge.net, Greg KH <gregkh@suse.de>,
       Alan Stern <stern@rowland.harvard.edu>,
       Oliver Neukum <oliver@neukum.org>, Mark Hindley <mark@hindley.org.uk>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Adrian Bunk <bunk@stusta.de>,
       sparclinux@vger.kernel.org, "William L. Irwin" <wli@holomorphy.com>,
       Mark Fortescue <mark@mtfhpc.demon.co.uk>, Ollie Wild <aaw@google.com>,
       David Miller <davem@davemloft.net>
Subject: Re: [3/3] 2.6.23-rc1: known regressions v3
References: <46AE0F5D.3000500@googlemail.com>
In-Reply-To: <46AE0F5D.3000500@googlemail.com>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is a list of some known regressions in 2.6.23-rc1.

Feel free to add new regressions/remove fixed etc.
http://kernelnewbies.org/known_regressions

List of Aces

Name                    Regressions fixed since 21-Jun-2007
Adrian Bunk                            6
Andi Kleen                             4
Andrew Morton                          4
Linus Torvalds                         4
Al Viro                                3
Jens Axboe                             3
Tejun Heo                              3
David Woodhouse                        2
Hugh Dickins                           2



USB

Subject         : 2.6.23-rc1: uhci_hcd. irq 4: nobody cared
References      : http://lkml.org/lkml/2007/7/29/75
Last known good : ?
Submitter       : Mark Hindley <mark@hindley.org.uk>
Caused-By       : ?
Handled-By      : Alan Stern <stern@rowland.harvard.edu>
Status          : unknown



Virtualization

Subject         : drivers/net/xen-netfront.c: bogus code
References      : http://lkml.org/lkml/2007/7/22/256
Last known good : ?
Submitter       : Adrian Bunk <bunk@stusta.de>
Caused-By       : ?
Handled-By      : Jeremy Fitzhardinge <jeremy@goop.org>
Status          : unknown



Sparc32

Subject         : NULL pointer derefference
References      : http://lkml.org/lkml/2007/7/29/224
                  http://lkml.org/lkml/2007/7/29/349
Last known good : ?
Submitter       : Mark Fortescue <mark@mtfhpc.demon.co.uk>
Caused-By       : Ollie Wild <aaw@google.com>
                  commit b6a2fea39318e43fee84fa7b0b90d68bed92d2ba
Handled-By      : ?
Status          : unknown



Regards,
Michal

--
LOG
http://www.stardust.webpages.pl/log/
