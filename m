Return-Path: <linux-kernel-owner+w=401wt.eu-S932903AbXIOCap@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932903AbXIOCap (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 22:30:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932730AbXIOC3i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 22:29:38 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:20414 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760150AbXIOC3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 22:29:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=sYft7H9ITUhpfINOZkYCMSnTJmsqibpOadDjxI1ZmBmCUrmjwnOdcPcZfqM9lY9Kz6OYlzkgNTDs5yGtDpaKY4VFe0+DzVpeJfkJw10drsF4y80aZoSL2GF6WUcswF8tRB1hlmNPLqE5Et8V/M2S0e6yl9lShMtGrMay7VowANs=
Message-ID: <46EB4377.7040200@googlemail.com>
Date: Sat, 15 Sep 2007 04:29:11 +0200
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Gabriel C <nix.or.die@googlemail.com>,
       Satyam Sharma <satyam.sharma@gmail.com>,
       Vitaly Bordug <vitb@kernel.crashing.org>, linux-acpi@vger.kernel.org,
       Len Brown <lenb@kernel.org>, Chuck Ebbert <cebbert@redhat.com>,
       Alexey Starikovskiy <aystarik@gmail.com>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>, Greg KH <gregkh@suse.de>,
       Anssi Hannula <anssi.hannula@gmail.com>,
       Christian Kujau <lists@nerdbynature.de>, jamal <hadi@cyberus.ca>,
       netdev@vger.kernel.org
Subject: 2.6.23-rc6: known regressions with patches v2
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is a list of some known regressions in 2.6.23-rc6
with patches available.

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



Unclassified

Subject         : Oops while modprobing phy fixed module
References      : http://lkml.org/lkml/2007/7/14/63
Last known good : ?
Submitter       : Gabriel C <nix.or.die@googlemail.com>
Caused-By       : ?
Handled-By      : Satyam Sharma <satyam.sharma@gmail.com>
                  Vitaly Bordug <vitb@kernel.crashing.org>
Patch1          : http://lkml.org/lkml/2007/7/18/506
Status          : patch available



ACPI

Subject         : 2.6.23-rc5 hangs on boot, apparently when initializing the EC
References      : http://lkml.org/lkml/2007/9/11/369
Last known good : ?
Submitter       : Chuck Ebbert <cebbert@redhat.com>
Caused-By       : ?
Handled-By      : Alexey Starikovskiy <aystarik@gmail.com>
Patch           : http://bugzilla.kernel.org/attachment.cgi?id=12673
Status          : patch was suggested



Drivercore

Subject         : sysfs change of input/event devices in 2.6.23rc breaks udev
References      : http://lkml.org/lkml/2007/9/8/86
Last known good : ?
Submitter       : Anssi Hannula <anssi.hannula@gmail.com>
Caused-By       : ?
Handled-By      : Dmitry Torokhov <dmitry.torokhov@gmail.com>
Patch           : http://lkml.org/lkml/2007/9/10/3
Status          : patch available



Networking

Subject         : 2.6.23-rc5: possible irq lock inversion dependency detected
References      : http://lkml.org/lkml/2007/9/2/97
Last known good : ?
Submitter       : Christian Kujau <lists@nerdbynature.de>
Caused-By       : ?
Handled-By      : jamal <hadi@cyberus.ca>
Patch           : http://lkml.org/lkml/2007/9/11/159
Status          : patch available



Farewell!
Michal

--
LOGOUT
http://www.stardust.webpages.pl/
