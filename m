Return-Path: <linux-kernel-owner+w=401wt.eu-S967008AbXG3Qfc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967008AbXG3Qfc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 12:35:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966786AbXG3QeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 12:34:21 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:29457 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966677AbXG3QeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 12:34:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:subject:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=q0ovPFOi4LRDCt5JEM2QsriOOFiwGQPsQ9z61HI+zw/gK+mN0zPyEIk1aEtrp/0rpArP0CtMWWEwdDvzFV9smzvKz5y2Nn9TSGyf8qNYkPlsOQKD5YgNQbSAARgQejBAnrFlW8X55z9D3yR4Jv3RH7rMLqBN5Xb728ykeu/K2OM=
Message-ID: <46AE1304.80408@googlemail.com>
Date: Mon, 30 Jul 2007 18:34:12 +0200
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Gabriel C <nix.or.die@googlemail.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Satyam Sharma <satyam.sharma@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Kay Sievers <kay.sievers@gmail.com>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       Vitaly Bordug <vitb@kernel.crashing.org>, Ingo Molnar <mingo@elte.hu>,
       Markus <lists4me@web.de>
Subject: [1/3] 2.6.23-rc1: known regressions with patches v3
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



Unclassified

Subject         : pcwd_init_module(): WARNING: at lib/kref.c:33 kref_get()
References      : http://lkml.org/lkml/2007/7/22/94
Last known good : ?
Submitter       : Ingo Molnar <mingo@elte.hu>
Caused-By       : ?
Handled-By      : Wim Van Sebroeck <wim@iguana.be>
Patch           : http://lkml.org/lkml/2007/7/29/235
Status          : patch available

Subject         : konqueror suddenly vanishing, "konqueror: Fatal IO error: client killed"
References      : http://lkml.org/lkml/2007/7/22/86
Last known good : ?
Submitter       : Markus <lists4me@web.de>
Caused-By       : ?
Handled-By      : Ingo Molnar <mingo@elte.hu>
Status          : problem is being debugged

Subject         : kobject link failure
References      : http://lkml.org/lkml/2007/7/19/495
Last known good : ?
Submitter       : Jan Engelhardt <jengelh@linux01.gwdg.de>
Caused-By       : ?
Handled-By      : Cornelia Huck <cornelia.huck@de.ibm.com>
                  Greg Kroah-Hartman <gregkh@suse.de>
Patch           : http://lkml.org/lkml/2007/7/20/143
Status          : patch available

Subject         : Kconfig prompts without help text
References      : http://lkml.org/lkml/2007/7/16/326
Last known good : ?
Submitter       : Stefan Richter <stefanr@s5r6.in-berlin.de>
Caused-By       : ?
Handled-By      : Jan Engelhardt <jengelh@linux01.gwdg.de>
Patch           : http://lkml.org/lkml/2007/7/18/236
Status          : patch available

Subject         : Oops while modprobing phy fixed module
References      : http://lkml.org/lkml/2007/7/14/63
Last known good : ?
Submitter       : Gabriel C <nix.or.die@googlemail.com>
Caused-By       : ?
Handled-By      : Satyam Sharma <satyam.sharma@gmail.com>
                  Vitaly Bordug <vitb@kernel.crashing.org>
Patch1          : http://lkml.org/lkml/2007/7/18/506
Status          : patch available



Regards,
Michal

--
LOG
http://www.stardust.webpages.pl/log/
