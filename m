Return-Path: <linux-kernel-owner+w=401wt.eu-S1761285AbXHTQDK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761285AbXHTQDK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 12:03:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760906AbXHTQC1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 12:02:27 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:5567 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760896AbXHTQCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 12:02:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=d0mZpHclnvJjjV8Nk5qqtmmKs133ph3xFCvBQFriuLYv4KXX00YIMJwnidEij3jvTFeByLlD9aLO1HvmdpmJCJhU+A5Hxd4DUT3tN8VSYZ+GhTihAPG2gjauy6REVTd+VXe9cs+ZGN/oY4LMQIvePAc+PR5Y3vIxTEX1CENrgp8=
Message-ID: <46C9BAF7.1050409@googlemail.com>
Date: Mon, 20 Aug 2007 18:01:59 +0200
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@ucw.cz>, Arkadiusz Miskiewicz <arekm@maven.pl>,
       Thomas Voegtle <tv@lio96.de>, linux-usb-devel@lists.sourceforge.net,
       Greg KH <gregkh@suse.de>, Alan Stern <stern@rowland.harvard.edu>,
       Oliver Neukum <oliver@neukum.org>, Tino Keitel <tino.keitel@gmx.de>,
       "Stuart_Hayes@Dell.com" <Stuart_Hayes@Dell.com>,
       Daniel Exner <dex@dragonslave.de>
Subject: Re: [4/4] 2.6.23-rc3: known regressions v2
References: <46C9B6C7.5070704@googlemail.com>
In-Reply-To: <46C9B6C7.5070704@googlemail.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is a list of some known regressions in 2.6.23-rc3.

Feel free to add new regressions/remove fixed etc.
http://kernelnewbies.org/known_regressions

List of Aces

Name                    Regressions fixed since 21-Jun-2007
Adrian Bunk                            9
Andi Kleen                             5
Linus Torvalds                         5
Andrew Morton                          4
Al Viro                                3
Cornelia Huck                          3
Jens Axboe                             3
Tejun Heo                              3



Power management

Subject         : 2.6.23-rc2 swsusp, suddenly increased uptime
References      : http://lkml.org/lkml/2007/8/12/249
Last known good : ?
Submitter       : Thomas Voegtle <tv@lio96.de>
Caused-By       : ?
Handled-By      : Rafael J. Wysocki <rjw@sisk.pl>
Status          : problem is being debugged

Subject         : resume from ram much slower
References      : http://lkml.org/lkml/2007/8/10/275
Last known good : 2.6.23-rc1 ?
Submitter       : Arkadiusz Miskiewicz <arekm@maven.pl>
Caused-By       : ?
Handled-By      : Rafael J. Wysocki <rjw@sisk.pl>
Status          : problem is being debugged



USB

Subject         : USB-related oops in sysfs with linux v2.6.23-rc3-50-g28e8351
References      : http://lkml.org/lkml/2007/8/15/144
Last known good : ?
Submitter       : Florin Iucha <florin@iucha.net>
Caused-By       : ?
Handled-By      : ?
Status          : problem is being debugged

Subject         : EHCI Regression in 2.6.23-rc2
References      : http://lkml.org/lkml/2007/8/10/81
Last known good : ?
Submitter       : Daniel Exner <dex@dragonslave.de>
Caused-By       : Stuart_Hayes@Dell.com <Stuart_Hayes@Dell.com>
                  commit 196705c9bbc03540429b0f7cf9ee35c2f928a534
Handled-By      : ?
Status          : unknown

Subject         : 2.6.23-rc1: USB hard disk broken
References      : http://lkml.org/lkml/2007/7/25/62
Last known good : ?
Submitter       : Tino Keitel <tino.keitel@gmx.de>
Caused-By       : ?
Handled-By      : Oliver Neukum <oliver@neukum.org>
Status          : unknown



Regards,
Michal

--
LOG
http://www.stardust.webpages.pl/log/
