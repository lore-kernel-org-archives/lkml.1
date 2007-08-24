Return-Path: <linux-kernel-owner+w=401wt.eu-S1760539AbXHXRjv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760539AbXHXRjv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 13:39:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763272AbXHXRjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 13:39:08 -0400
Received: from fk-out-0910.google.com ([209.85.128.185]:8533 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764018AbXHXRjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 13:39:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=EfngkIiR/CM2C0qnIGCoYm+8uxafx8iIA+BkCtAClmSDudf0fdbEuIjfwyN7+QjiDsNPgrrGXI2BAUFNt3S+9fyQHEG3y4EzKru+4sZJ/cDDSIbr8vwCC6kgn6H6rU9qHverjwTgMtQe3A/EXmQ/+Z1A0Ylm0XTH8/QZW+0S13w=
Message-ID: <46CF17A0.2060503@googlemail.com>
Date: Fri, 24 Aug 2007 19:38:40 +0200
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-usb-devel@lists.sourceforge.net, Greg KH <gregkh@suse.de>,
       Alan Stern <stern@rowland.harvard.edu>,
       Oliver Neukum <oliver@neukum.org>, Tino Keitel <tino.keitel@gmx.de>,
       Parag Warudkar <parag.warudkar@gmail.com>,
       Zachary Amsden <zach@vmware.com>, linux-alpha@vger.kernel.org,
       Richard Henderson <rth@twiddle.net>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Oliver Falk <oliver@linux-kernel.at>
Subject: Re: [4/4] 2.6.23-rc3: known regressions v3
References: <46CF0DEF.5040107@googlemail.com>
In-Reply-To: <46CF0DEF.5040107@googlemail.com>
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
Alan Stern                             3
Cornelia Huck                          3
Jens Axboe                             3
Tejun Heo                              3



USB

Subject         : 2.6.23-rc1: USB hard disk broken
References      : http://lkml.org/lkml/2007/7/25/62
Last known good : ?
Submitter       : Tino Keitel <tino.keitel@gmx.de>
Caused-By       : ?
Handled-By      : Oliver Neukum <oliver@neukum.org>
Status          : unknown



Virtualization

Subject         : CONFIG_VMI broken
References      : http://lkml.org/lkml/2007/8/14/203
Last known good : ?
Submitter       : Parag Warudkar <parag.warudkar@gmail.com>
Caused-By       : ?
Handled-By      : Zachary Amsden <zach@vmware.com>
Status          : problem is being debugged



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
