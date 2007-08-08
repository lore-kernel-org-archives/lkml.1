Return-Path: <linux-kernel-owner+w=401wt.eu-S935897AbXHHRNk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935897AbXHHRNk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 13:13:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765810AbXHHRNI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 13:13:08 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:5643 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763590AbXHHRNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 13:13:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=T6Ao8dmH1cY1ZmoBvHB41nPLyiAfFJ/L/uMu6ZcmbQVmq6K9FQKvShk0SB/yHCcJ0eEQBcSa6HMJ5K9Dj7oneA2NvxYfOhvpQCXU4RrP36WGDe1bX4onbKiPfPPP1hIBNRIDCgTp92U9HnmEfs4uERCfmtKgboygrdE1igaE/6w=
Message-ID: <46B9F983.9020700@googlemail.com>
Date: Wed, 08 Aug 2007 19:12:35 +0200
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@ucw.cz>, Meelis Roos <mroos@linux.ee>,
       linux-scsi@vger.kernel.org, Andrew Vasquez <linux-driver@qlogic.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       linux-usb-devel@lists.sourceforge.net, Greg KH <gregkh@suse.de>,
       Alan Stern <stern@rowland.harvard.edu>,
       Oliver Neukum <oliver@neukum.org>, Tino Keitel <tino.keitel@gmx.de>,
       Mark Hindley <mark@hindley.org.uk>, Richard Henderson <rth@twiddle.net>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Oliver Falk <oliver@linux-kernel.at>
Subject: Re: [3/3] 2.6.23-rc2: known regressions v2
References: <46B9F664.9060600@googlemail.com>
In-Reply-To: <46B9F664.9060600@googlemail.com>
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
Peter Zijlstra                         2
Trent Piepho                           2



Power management

Subject         : Kconfig: 'SUSPEND_SMP' refers to undefined symbol 'HOTPLUG_CPU'
References      : http://lkml.org/lkml/2007/8/4/39
Last known good : ?
Submitter       : Meelis Roos <mroos@linux.ee>
Caused-By       : ?
Handled-By      : Rafael J. Wysocki <rjw@sisk.pl>
Status          : unknown



SCSI

Subject         : unable to handle kernel NULL pointer dereference in qla2x00_read_nvram_data
References      : http://lkml.org/lkml/2007/8/6/506
Last known good : ?
Submitter       : Zhang, Yanmin <yanmin_zhang@linux.intel.com>
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



Alpha

Subject         : -Werror compilation problem - make[1]: *** [arch/alpha/kernel/sys_titan.o] Error 1
References      : http://lkml.org/lkml/2007/8/6/137
Last known good : ?
Submitter       : Oliver Falk <oliver@linux-kernel.at>
Caused-By       : ?
Handled-By      : ?
Status          : unknown



Regards,
Michal

--
LOG
http://www.stardust.webpages.pl/log/
