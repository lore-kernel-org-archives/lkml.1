Return-Path: <linux-kernel-owner+w=401wt.eu-S967149AbXG3QgX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967149AbXG3QgX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 12:36:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966990AbXG3Qeg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 12:34:36 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:6001 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966986AbXG3Qed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 12:34:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=XpQA2mFd7Y/Fbv8JovCiPzAk7BMOsvfCLDYmfS5mmJ6OD2WlTFDQRJzgC5fBQU4auqriAXCOy3qpQMxLeQfNcmYdrSuFZ+7wcYzGr+O3ojiCyvHEN7X2apvgKa3HRR5IbIypoL0tIOG2M9gOG7V3yJP7eez0HcPZj1vbzr/wriQ=
Message-ID: <46AE1313.2020103@googlemail.com>
Date: Mon, 30 Jul 2007 18:34:27 +0200
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-usb-devel@lists.sourceforge.net, Greg KH <gregkh@suse.de>,
       Alan Stern <stern@rowland.harvard.edu>,
       Oliver Neukum <oliver@neukum.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Tino Keitel <tino.keitel@gmx.de>,
       Mark Hindley <mark@hindley.org.uk>
Subject: Re: [3/3] 2.6.23-rc1: known regressions with patches v3
References: <46AE114F.2010201@googlemail.com>
In-Reply-To: <46AE114F.2010201@googlemail.com>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is a list of some known regressions in 2.6.23-rc1
with patches available.

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

Subject         : 2.6.23-rc1: USB hard disk broken
References      : http://lkml.org/lkml/2007/7/25/62
Last known good : ?
Submitter       : Tino Keitel <tino.keitel@gmx.de>
Caused-By       : ?
Handled-By      : Oliver Neukum <oliver@neukum.org>
Status          : unknown

Subject         : BUG: sleeping function called from invalid context at drivers/usb/core/urb.c:524,in_atomic():1, irqs_disabled():0
References      : http://lkml.org/lkml/2007/7/23/400
Last known good : ?
Submitter       : Jeremy Fitzhardinge <jeremy@goop.org>
Caused-By       : ?
Handled-By      : Oliver Neukum <oliver@neukum.org>
Patch           : http://lkml.org/lkml/2007/7/24/203
Status          : patch available



Regards,
Michal

--
LOG
http://www.stardust.webpages.pl/log/
