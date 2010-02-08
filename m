Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751489Ab0BHMfH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 07:35:07 -0500
Received: from adelie.canonical.com ([91.189.90.139]:60733 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182Ab0BHMfE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 07:35:04 -0500
Message-ID: <4B7004F4.3030804@canonical.com>
Date: Mon, 08 Feb 2010 13:35:00 +0100
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Len Brown <len.brown@intel.com>, Zhang Rui <rui.zhang@intel.com>
Subject: Re: [Bug #15096] Resume lock up -- bisected, commit 3a1151e3f124fd1a2c54b8153f510f1a7c715369
References: <2uzMDuY-7_O.A.M1G.7X1bLB@chimera> <iuJeop2ribM.A.fyH.fY1bLB@chimera> <b170af451002072345x1e7666adv7f105a5f847f4d0d@mail.gmail.com> <201002081156.24020.rjw@sisk.pl>
In-Reply-To: <201002081156.24020.rjw@sisk.pl>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Monday 08 February 2010, Rafał Miłecki wrote:
>> 2010/2/8 Rafael J. Wysocki <rjw@sisk.pl>:
>>> This message has been generated automatically as a part of a report
>>> of regressions introduced between 2.6.31 and 2.6.32.
>>>
>>> The following bug entry is on the current list of known regressions
>>> introduced between 2.6.31 and 2.6.32.  Please verify if it still should
>>> be listed and let the tracking team know (either way).
>>>
>>>
>>> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=15096
>>> Subject         : Resume lock up -- bisected, commit 3a1151e3f124fd1a2c54b8153f510f1a7c715369
>>> Submitter       : Rafał Miłecki <zajec5@gmail.com>
>>> Date            : 2010-01-20 23:15 (19 days old)
>>> First-Bad-Commit: http://git.kernel.org/git/linus/3a1151e3f124fd1a2c54b8153f510f1a7c715369
> 
> It looks like we should revert this commit, seems broken.

Hm, otoh we had definitely people with some Asus laptops who where only be able
to use backlight control with it. So I would rather prefer some work around to
the suspend/resume problem (_DOS if I understood correctly).

Stefan

> Anyway, I'll do my best to have a look at this bug later today.
> 
> Rafael


