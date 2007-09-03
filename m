Return-Path: <linux-kernel-owner+w=401wt.eu-S1756428AbXICKMQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756428AbXICKMQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 06:12:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755213AbXICKLk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 06:11:40 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:14453 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757843AbXICKLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 06:11:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=HyLU/Egdl7EucELfW/gAwv9NAIMZuknjpTMdz56E/fYsYGrMbUWB1jQPtGefm77U/YTVm1HQrSIyFV6Hrzw6+bT33ZNkjzWmylMeg+W+QnLnDknfKj3vS1opCJH54+f3E/u5lpnhXihIeee5X7zrS9vI5bzjy9Yi1y6yyVm++3s=
Message-ID: <46DBDDB5.7080307@googlemail.com>
Date: Mon, 03 Sep 2007 12:11:01 +0200
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@ucw.cz>, Arkadiusz Miskiewicz <arekm@maven.pl>,
       Thomas Voegtle <tv@lio96.de>, Soeren Sonnenburg <kernel@nn7.de>,
       Christian Leber <christian@leber.de>,
       linux-usb-devel@lists.sourceforge.net, Greg KH <gregkh@suse.de>,
       Alan Stern <stern@rowland.harvard.edu>,
       Oliver Neukum <oliver@neukum.org>, Tino Keitel <tino.keitel@gmx.de>
Subject: Re: [4/4] 2.6.23-rc5: known regressions
References: <46DBD982.3080102@googlemail.com>
In-Reply-To: <46DBD982.3080102@googlemail.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is a list of some known regressions in 2.6.23-rc5.

Feel free to add new regressions/remove fixed etc.
http://kernelnewbies.org/known_regressions

List of Aces

Name                    Regressions fixed since 21-Jun-2007
Adrian Bunk                            9
Linus Torvalds                         6
Andi Kleen                             5
Hugh Dickins                           5
Andrew Morton                          4
Al Viro                                3
Alan Stern                             3
Alexey Starikovskiy                    3
Cornelia Huck                          3
Jens Axboe                             3
Stephen Hemminger                      3
Tejun Heo                              3



Power management

Subject         : powersaving degradation, (time spend in C0 goes up after a while)
References      : http://lkml.org/lkml/2007/9/2/142
Last known good : ?
Submitter       : Christian Leber <christian@leber.de>
Caused-By       : ?
Handled-By      : ?
Status          : unknown

Subject         : something broke resume from s2ram on mbp c1d (??? :))
References      : http://lkml.org/lkml/2007/8/28/67
Last known good : 2.6.23-rc3
Submitter       : Soeren Sonnenburg <kernel@nn7.de>
Caused-By       : ?
Handled-By      : Rafael J. Wysocki <rjw@sisk.pl>
Status          : unknown

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
