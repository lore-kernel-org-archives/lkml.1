Return-Path: <linux-kernel-owner+w=401wt.eu-S938064AbXG0U6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938064AbXG0U6l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 16:58:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937863AbXG0U4X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 16:56:23 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:20943 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937681AbXG0U4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 16:56:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:subject:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=YvhWYJatgdDpDUvmLO7krLrwG5T5hMxCAbgPIq+MGXM2GNgKHfLbB0128YWJmIsqnhLkxuzi3zJTJqGHUDZ2eUnH/hHjD+fafXhDwZuYEpu8ao8SDd/D31ZowPNVvSCg0EKlDZWpsByE5qitwf5+JC2oXOANPZFOc9DnOfIcRdo=
Message-ID: <46AA5B44.2030909@googlemail.com>
Date: Fri, 27 Jul 2007 22:53:24 +0200
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
       Vitaly Bordug <vitb@kernel.crashing.org>, linux-fsdevel@vger.kernel.org,
       Doug Chapman <doug.chapman@hp.com>, Vasily Tarasov <vtaras@openvz.org>,
       Tony Luck <tony.luck@intel.com>, Jeff Garzik <jeff@garzik.org>,
       Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [1/2] 2.6.23-rc1: known regressions with patches v2
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
Patch           : http://lkml.org/lkml/2007/7/18/506
Status          : patch available



FS

Subject         : NFSv4 poops itself
References      : http://lkml.org/lkml/2007/7/27/144
Last known good : ?
Submitter       : Jeff Garzik <jeff@garzik.org> 
Caused-By       : ?
Handled-By      : Trond Myklebust <Trond.Myklebust@netapp.com>
Patch           : http://lkml.org/lkml/2007/7/27/183
Status          : patch available

Subject         : ia64 build failure from recent diskquota patch
References      : http://lkml.org/lkml/2007/7/18/407
Last known good : ?
Submitter       : Doug Chapman <doug.chapman@hp.com>
Caused-By       : Vasily Tarasov <vtaras@openvz.org>
                  commit b716395e2b8e450e294537de0c91476ded2f0395
Handled-By      : Luck, Tony <tony.luck@intel.com>
Patch1          : http://lkml.org/lkml/2007/7/20/255
Patch2          : http://lkml.org/lkml/2007/7/20/272
Status          : patch available



Regards,
Michal

--
LOG
http://www.stardust.webpages.pl/log/
