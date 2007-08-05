Return-Path: <linux-kernel-owner+w=401wt.eu-S1759528AbXHEQ2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759528AbXHEQ2a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 12:28:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758264AbXHEQ1s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 12:27:48 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:26483 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758179AbXHEQ1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 12:27:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=JqANA9mjcJn7IBDmC7pue17g1LK0cN+5IKMsHDyyECvc6CwFd6NfV7sV1cf95fPEK90W3FGd12SfSbQePATGMOpY88Y0jovGYWMr69/dMu3Z9NVdsW2RYtiooXUrP39QuFo8UgK+fN5yWw87xxR+qh/SXLj0NHsf5VZdOoMnXLw=
Message-ID: <46B5FA39.5050907@googlemail.com>
Date: Sun, 05 Aug 2007 18:26:33 +0200
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org,
       James Bottomley <James.Bottomley@steeleye.com>,
       James Smart <James.Smart@emulex.com>, Adrian Bunk <bunk@stusta.de>,
       linux-usb-devel@lists.sourceforge.net, Greg KH <gregkh@suse.de>,
       Alan Stern <stern@rowland.harvard.edu>,
       Oliver Neukum <oliver@neukum.org>, Tino Keitel <tino.keitel@gmx.de>,
       Mark Hindley <mark@hindley.org.uk>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [3/3] 2.6.23-rc2: known regressions
References: <46B5F74D.7010708@googlemail.com>
In-Reply-To: <46B5F74D.7010708@googlemail.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is a list of some known regressions in 2.6.23-rc2.

Feel free to add new regressions/remove fixed etc.
http://kernelnewbies.org/known_regressions

List of Aces

Name                    Regressions fixed since 21-Jun-2007
Adrian Bunk                            6
Andi Kleen                             4
Andrew Morton                          4
Linus Torvalds                         4
Al Viro                                3
Cornelia Huck                          3
Jens Axboe                             3
Tejun Heo                              3
David Woodhouse                        2
Hugh Dickins                           2
Trent Piepho                           2



SCSI

Subject         : lpfc_sli.c: off-by-10
References      : http://lkml.org/lkml/2007/7/22/284
Last known good : ?
Submitter       : Adrian Bunk <bunk@stusta.de>
Caused-By       : ?
Handled-By      : ?
Status          : unknown



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



Virtualization

Subject         : drivers/net/xen-netfront.c: bogus code
References      : http://lkml.org/lkml/2007/7/22/256
Last known good : ?
Submitter       : Adrian Bunk <bunk@stusta.de>
Caused-By       : ?
Handled-By      : Jeremy Fitzhardinge <jeremy@goop.org>
Status          : unknown



Regards,
Michal

--
LOG
http://www.stardust.webpages.pl/log/
