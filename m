Return-Path: <linux-kernel-owner+w=401wt.eu-S967024AbXG3Qen@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967024AbXG3Qen (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 12:34:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966281AbXG3QeK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 12:34:10 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:29457 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965802AbXG3QeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 12:34:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=nWJ42OX7hxzRD5WkFi/dPwLTm+j7f7xfcRgzDiyw7bTKGowbZZGO0Zd7QshTvgsVXsUB5ZQ4awxcLHkPXuO5jhbsX0sogepxYtmxuJTGltudFfxQ/0fF5p+8AceUIiWk4yyhU7t2PwfHKolt6roY1Ewb/3P9QJYkMggdESxyGY4=
Message-ID: <46AE12F5.4030706@googlemail.com>
Date: Mon, 30 Jul 2007 18:33:57 +0200
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
       Denis Sadykov <denis.m.sadykov@intel.com>, dth <dth@dth.net>,
       Netdev <netdev@vger.kernel.org>,
       Stephen Hemminger <shemminger@osdl.org>, Thomas Meyer <thomas@m3y3r.de>,
       Florian Lohoff <flo@rfc822.org>,
       =?ISO-8859-2?Q?Ismail_D=F6nmez?= <ismail@pardus.org.tr>,
       linux-acpi@vger.kernel.org, linux-scsi@vger.kernel.org,
       James Bottomley <James.Bottomley@steeleye.com>,
       James Smart <James.Smart@emulex.com>, Adrian Bunk <bunk@stusta.de>
Subject: Re: [2/3] 2.6.23-rc1: known regressions v3
References: <46AE0F5D.3000500@googlemail.com>
In-Reply-To: <46AE0F5D.3000500@googlemail.com>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is a list of some known regressions in 2.6.23-rc1.

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



CPUFREQ/ACPI

Subject         : ide problems: 2.6.22-git17 working, 2.6.23-rc1* is not
References      : http://lkml.org/lkml/2007/7/27/298
                  http://lkml.org/lkml/2007/7/29/371
Last known good : ?
Submitter       : dth <dth@dth.net>
Caused-By       : ?
Handled-By      : ?
Status          : unknown



Networking

Subject         : sky2 boot crash in sky2_mac_intr
References      : http://lkml.org/lkml/2007/7/24/91
Last known good : ?
Submitter       : Florian Lohoff <flo@rfc822.org>
Caused-By       : 
Handled-By      : Stephen Hemminger <shemminger@osdl.org>
Status          : unknown

Subject         : New wake ups from sky2
References      : http://lkml.org/lkml/2007/7/20/386
Last known good : ?
Submitter       : Thomas Meyer <thomas@m3y3r.de>
Caused-By       : Stephen Hemminger <shemminger@osdl.org>
                  commit eb35cf60e462491249166182e3e755d3d5d91a28
Handled-By      : Stephen Hemminger <shemminger@osdl.org>
Status          : unknown



Power Management

Subject         : New ACPI error/warning with Linus' latest GIT
References      : http://lkml.org/lkml/2007/7/26/395
Last known good : ?
Submitter       : Ismail Dönmez <ismail@pardus.org.tr>
Caused-By       : ?
Handled-By      : ?
Status          : unknown



SCSI

Subject         : lpfc_sli.c: off-by-10
References      : http://lkml.org/lkml/2007/7/22/284
Last known good : ?
Submitter       : Adrian Bunk <bunk@stusta.de>
Caused-By       : ?
Handled-By      : ?
Status          : unknown



Regards,
Michal

--
LOG
http://www.stardust.webpages.pl/log/
