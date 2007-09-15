Return-Path: <linux-kernel-owner+w=401wt.eu-S1760343AbXIOC3y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760343AbXIOC3y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 22:29:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932263AbXIOC33
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 22:29:29 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:20484 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760010AbXIOC30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 22:29:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=uLKOvfb0btP889mzVojDYg84uhoxFSWr13Xz65LGRE4UODBHMkwx4S7Cx2ZH95p1CP8wtcRrWhStFZf4/MupI/lUVgQlroN9MbgGrMcSRnXRuF1UIzxkh9JQjnzoIBjkRDns/3ywJarJt3Q7Ln86XSibPHwEA/5NN0XM6KiUCVU=
Message-ID: <46EB4371.307@googlemail.com>
Date: Sat, 15 Sep 2007 04:29:05 +0200
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@austin.ibm.com>,
       jfs-discussion@lists.sourceforge.net, Andy Whitcroft <apw@shadowen.org>,
       sct@redhat.com, adilger@clusterfs.com, linux-ext4@vger.kernel.org,
       netdev@vger.kernel.org, Shish <shish@shishnet.org>,
       Karl Meyer <adhocrocker@gmail.com>,
       Francois Romieu <romieu@fr.zoreil.com>, Daniel Drake <dsd@gentoo.org>,
       Oliver Neukum <oliver@neukum.org>,
       linux-usb-devel@lists.sourceforge.net, Florian Lohoff <flo@rfc822.org>,
       =?ISO-8859-2?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>
Subject: Re: [2/3] 2.6.23-rc6: known regressions v2
References: <46EB3E94.7080704@googlemail.com>
In-Reply-To: <46EB3E94.7080704@googlemail.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is a list of some known regressions in 2.6.23-rc6.

Feel free to add new regressions/remove fixed etc.
http://kernelnewbies.org/known_regressions

List of Aces

Name                    Regressions fixed since 21-Jun-2007
Adrian Bunk                            10
Andi Kleen                             7
Linus Torvalds                         6
Alan Stern                             5
Hugh Dickins                           5
Trond Myklebust                        5
Andrew Morton                          4
David S. Miller                        4
Al Viro                                3
Alexey Starikovskiy                    3
Cornelia Huck                          3
Jens Axboe                             3
Stephen Hemminger                      3
Tejun Heo                              3



FS

Subject         : hanging ext3 dbench tests
References      : http://lkml.org/lkml/2007/9/11/176
Last known good : ?
Submitter       : Andy Whitcroft <apw@shadowen.org>
Caused-By       : ?
Handled-By      : ?
Status          : under test -- unreproducible at present

Subject         : umount triggers a warning in jfs and takes almost a minute
References      : http://lkml.org/lkml/2007/9/4/73
Last known good : ?
Submitter       : Oliver Neukum <oliver@neukum.org>
Caused-By       : ?
Handled-By      : ?
Status          : unknown



Networking

Subject         : build #301 failed for 2.6.23-rc6-g0d4cbb5 in linux/drivers/net/wireless/libertas/
References      : http://lkml.org/lkml/2007/9/11/150
Last known good : ?
Submitter       : Toralf Förster <toralf.foerster@gmx.de>
Caused-By       : ?
Handled-By      : ?
Status          : unknown

Subject         : zd1211rw regression, device does not enumerate
References      : http://marc.info/?l=linux-usb-devel&m=118854967709322&w=2
                  http://bugzilla.kernel.org/show_bug.cgi?id=8972
Last known good : ?
Submitter       : Oliver Neukum <oliver@neukum.org>
Caused-By       : Daniel Drake <dsd@gentoo.org>
                  commit 74553aedd46b3a2cae986f909cf2a3f99369decc
Handled-By      : ?
Status          : unknown

Subject         : NETDEV WATCHDOG: eth0: transmit timed out
References      : http://lkml.org/lkml/2007/8/13/737
Last known good : ?
Submitter       : Karl Meyer <adhocrocker@gmail.com>
Caused-By       : ?
Handled-By      : Francois Romieu <romieu@fr.zoreil.com>
Status          : problem is being debugged

Subject         : Weird network problems with 2.6.23-rc2
References      : http://lkml.org/lkml/2007/8/11/40
Last known good : ?
Submitter       : Shish <shish@shishnet.org>
Caused-By       : ?
Handled-By      : ?
Status          : unknown



Farewell!
Michal

--
LOGOUT
http://www.stardust.webpages.pl/
