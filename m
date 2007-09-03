Return-Path: <linux-kernel-owner+w=401wt.eu-S1757066AbXICKLd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757066AbXICKLd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 06:11:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753875AbXICKLA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 06:11:00 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:13161 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753978AbXICKK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 06:10:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=kxJx4NgeOVA+Wr6elrCQ5e7j5FjJocUEznUT8/cKKIxPOJ0S9GdgUd9cC3xC/sWy8cyKjF9C9a8WBc4EpYCEvCHVAZ+eaCjI/ZzTO9CW1AvZNu4E+g0OuBuokKmu1WwzCEbwNwDgoTi1QOqzGt3tkIVYHZREdX0KEtTBg9cXKjk=
Message-ID: <46DBDD8E.6050802@googlemail.com>
Date: Mon, 03 Sep 2007 12:10:22 +0200
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
       Shish <shish@shishnet.org>, Karl Meyer <adhocrocker@gmail.com>,
       Francois Romieu <romieu@fr.zoreil.com>, linux-wireless@vger.kernel.org,
       Christian Casteyde <casteyde.christian@free.fr>,
       Martin Langer <martin-langer@gmx.de>, Stefano Brivio <st3@riseup.net>,
       Michael Buesch <mbuesch@freenet.de>,
       Danny van Dyk <kugelfang@gentoo.org>,
       Andreas Jaggi <andreas.jaggi@waterwave.ch>,
       Daniel Drake <dsd@gentoo.org>, Oliver Neukum <oliver@neukum.org>,
       linux-usb-devel@lists.sourceforge.net, Florian Lohoff <flo@rfc822.org>
Subject: Re: [3/4] 2.6.23-rc5: known regressions
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



Networking

Subject         : ifconfig eth1 - scheduling while atomic: ifconfig/0x00000002/4170
References      : http://lkml.org/lkml/2007/9/2/165
Last known good : ?
Submitter       : Florian Lohoff <flo@rfc822.org> 
Caused-By       : ?
Handled-By      : ?
Status          : unknown

Subject         : zd1211rw regression, device does not enumerate
References      : http://marc.info/?l=linux-usb-devel&m=118854967709322&w=2
Last known good : ?
Submitter       : Oliver Neukum <oliver@neukum.org>
Caused-By       : Daniel Drake <dsd@gentoo.org>
                  commit 74553aedd46b3a2cae986f909cf2a3f99369decc
Handled-By      : ?
Status          : unknown

Subject         : System freeze when restarting network connection with Broadcom driver
References      : http://bugzilla.kernel.org/show_bug.cgi?id=8934
Last known good : ?
Submitter       : Christian Casteyde <casteyde.christian@free.fr>
Caused-By       : ?
Handled-By      : ?
Status          : problem is being debugged

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



Regards,
Michal

--
LOG
http://www.stardust.webpages.pl/log/
