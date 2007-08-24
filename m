Return-Path: <linux-kernel-owner+w=401wt.eu-S1759198AbXHXRis@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759198AbXHXRis (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 13:38:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759749AbXHXRiV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 13:38:21 -0400
Received: from ik-out-1112.google.com ([66.249.90.178]:26411 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757667AbXHXRiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 13:38:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=gq3nyMMg3KqNEIYFrupc83GWwwK8wcsGJrsnU0eyPnAURa+5OuQNIhM0ekU9cMkZR+3Zjm8uHmxzJUneB/0naNGEq0yauIszTKkKcljPuRkLSHyaHs+xJVxGiRUUwXhVhhNPgaWXjAn73hGpB2BF8my9O5xDMEDWr6wk7YGBaNo=
Message-ID: <46CF177B.4090608@googlemail.com>
Date: Fri, 24 Aug 2007 19:38:03 +0200
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Markus <lists4me@web.de>, Jeff Chua <jeff.chua.linux@gmail.com>,
       "Antonino A. Daplas" <adaplas@gmail.com>, Jan Dittmer <jdi@l4x.org>,
       Christian Zankel <chris@zankel.net>, linux-alpha@vger.kernel.org,
       Stefan Becker <Stefan.Becker@nokia.com>, alsa-devel@alsa-project.org,
       Jaroslav Kysela <perex@suse.cz>, Takashi Iwai <tiwai@suse.de>,
       "Ivan N. Zlatev" <contact@i-nz.net>, Thomas Meyer <thomas@m3y3r.de>
Subject: [1/4] 2.6.23-rc3: known regressions v3
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



Unclassified

Subject         : 2.6.23-rc3-git1 crash/stuck on VIA CN700 system
References      : http://lkml.org/lkml/2007/8/20/174
Last known good : ?
Submitter       : Stefan Becker <Stefan.Becker@nokia.com>
Caused-By       : ?
Handled-By      : ?
Status          : unknown

Subject         : 2.6.23-rc2 cross compile regressions (alpha,xtensa)
References      : http://lkml.org/lkml/2007/8/6/43
Last known good : alpha: 2.6.22-git8
                  xtensa: 2.6.22-git6
Submitter       : Jan Dittmer <jdi@l4x.org>
Caused-By       : ?
Handled-By      : xtensa: Christian Zankel <chris@zankel.net>
Status          : unknown

Subject         : console is messed up after resume from s2ram or switching to console from X
References      : http://lkml.org/lkml/2007/8/4/6
Last known good : ?
Submitter       : Jeff Chua <jeff.chua.linux@gmail.com>
Caused-By       : ?
Handled-By      : H. Peter Anvin <hpa@zytor.com>
                  Antonino A. Daplas <adaplas@gmail.com>
Workaround      : "s2ram --force --acpi_sleep 1 --vbe_mode"
Status          : problem is being debugged

Subject         : konqueror suddenly vanishing, "konqueror: Fatal IO error: client killed"
References      : http://lkml.org/lkml/2007/7/22/86
Last known good : ?
Submitter       : Markus <lists4me@web.de>
Caused-By       : ?
Handled-By      : Ingo Molnar <mingo@elte.hu>
Status          : problem is being debugged



ALSA

Subject         : Master volume control broken
References      : http://lkml.org/lkml/2007/8/18/46
Last known good : ?
Submitter       : Thomas Meyer <thomas@m3y3r.de>
Caused-By       : Ivan N. Zlatev <contact@i-nz.net>
                  commit 5d5d3bc3eddf2ad97b2cb090b92580e7fed6cee1
Handled-By      : ?
Status          : unknown



Regards,
Michal

--
LOG
http://www.stardust.webpages.pl/log/
