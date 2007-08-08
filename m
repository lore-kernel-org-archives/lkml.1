Return-Path: <linux-kernel-owner+w=401wt.eu-S937132AbXHHRMl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937132AbXHHRMl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 13:12:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935008AbXHHRMI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 13:12:08 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:8981 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764937AbXHHRME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 13:12:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=ofJVJ/jgjbvAJXkyHA48K0h22yY/oBMqNrA9tSVy9inE+uKiTFcYZiCEonNu1zzclZ/OmxcvaaAkV382pyTIcKczHqb5rlEmqF6Q1OcnFykOQevYLffEjpYEyBP9b4yVmoZ28EL4AlukqNrOdt31GqdXxjfggqWV9qA6ayBdro8=
Message-ID: <46B9F950.2030209@googlemail.com>
Date: Wed, 08 Aug 2007 19:11:44 +0200
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
       dth <dth@dth.net>, linux-fsdevel@vger.kernel.org,
       nfs@lists.sourceforge.net, Trond Myklebust <Trond.Myklebust@netapp.com>,
       Andrew Clayton <andrew@digital-domain.net>,
       linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, Netdev <netdev@vger.kernel.org>,
       Stephen Hemminger <shemminger@osdl.org>, Thomas Meyer <thomas@m3y3r.de>,
       Florian Lohoff <flo@rfc822.org>, Uwe Bugla <uwe.bugla@gmx.de>
Subject: Re: [2/3] 2.6.23-rc2: known regressions v2
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



CPUFREQ

Subject         : ide problems: 2.6.22-git17 working, 2.6.23-rc1* is not
References      : http://lkml.org/lkml/2007/7/27/298
                  http://lkml.org/lkml/2007/7/29/371
Last known good : ?
Submitter       : dth <dth@dth.net>
Caused-By       : Len Brown <lenb@kernel.org>
                  commit f79e3185dd0f8650022518d7624c876d8929061b
Handled-By      : Len Brown <lenb@kernel.org>
Status          : problem is being debugged



FS

Subject         : [NFSD OOPS] 2.6.23-rc1-git10
References      : http://lkml.org/lkml/2007/8/2/462
Last known good : ?
Submitter       : Andrew Clayton <andrew@digital-domain.net>
Caused-By       : ?
Handled-By      : ?
Status          : unknown



MTD

Subject         : error: implicit declaration of function 'cfi_interleave'
References      : http://lkml.org/lkml/2007/8/6/272
Last known good : ?
Submitter       : Ingo Molnar <mingo@elte.hu>
Caused-By       : ?
Handled-By      : ?
Status          : unknown



Networking

Subject         : IP v4 routing is broken
References      : http://www.stardust.webpages.pl/files/tbf/bugs/bug_report01.txt
Last known good : 2.6.22-git2
Submitter       : Uwe Bugla <uwe.bugla@gmx.de>
Caused-By       : ?
Handled-By      : ?
Status          : unknown

Subject         : New wake ups from sky2
References      : http://lkml.org/lkml/2007/7/20/386
Last known good : ?
Submitter       : Thomas Meyer <thomas@m3y3r.de>
Caused-By       : Stephen Hemminger <shemminger@osdl.org>
                  commit eb35cf60e462491249166182e3e755d3d5d91a28
Handled-By      : Stephen Hemminger <shemminger@osdl.org>
Status          : unknown



Regards,
Michal

--
LOG
http://www.stardust.webpages.pl/log/
