Return-Path: <linux-kernel-owner+w=401wt.eu-S932110AbXH2P3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932110AbXH2P3T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 11:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758523AbXH2P2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 11:28:48 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:62735 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758375AbXH2P2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 11:28:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=VB4DSQj1Lcgd9BS+3GQlIiTkusfBL8t38grkvDGcuzdEW0hdMmgoBJH7U5XxD2CBTqYFI18BpgcEztu+LBbgh5900IViBgZonzkxdzXwFnNYP7S3oQGr0ya5VIbxpC6KeHTIb7A0kppLCCccnLDBb/UfNARuvwxu8jAKbpPHA74=
Message-ID: <46D5906B.1030701@googlemail.com>
Date: Wed, 29 Aug 2007 17:27:39 +0200
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
       nfs@lists.sourceforge.net, Trond Myklebust <Trond.Myklebust@netapp.com>,
       Andrew Clayton <andrew@digital-domain.net>,
       kbuild-devel@lists.sourceforge.net,
       Roman Zippel <zippel@linux-m68k.org>, Sam Ravnborg <sam@ravnborg.org>,
       Hugh Dickins <hugh@veritas.com>, Netdev <netdev@vger.kernel.org>,
       Shish <shish@shishnet.org>, Karl Meyer <adhocrocker@gmail.com>,
       Francois Romieu <romieu@fr.zoreil.com>, linux-wireless@vger.kernel.org,
       Christian Casteyde <casteyde.christian@free.fr>,
       Martin Langer <martin-langer@gmx.de>, Stefano Brivio <st3@riseup.net>,
       Michael Buesch <mbuesch@freenet.de>,
       Danny van Dyk <kugelfang@gentoo.org>,
       Andreas Jaggi <andreas.jaggi@waterwave.ch>
Subject: Re: [3/4] 2.6.23-rc4: known regressions
References: <46D58CC6.4020605@googlemail.com>
In-Reply-To: <46D58CC6.4020605@googlemail.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is a list of some known regressions in 2.6.23-rc4.

Feel free to add new regressions/remove fixed etc.
http://kernelnewbies.org/known_regressions

List of Aces

Name                    Regressions fixed since 21-Jun-2007
Adrian Bunk                            9
Andi Kleen                             5
Linus Torvalds                         5
Andrew Morton                          4
Hugh Dickins                           4
Al Viro                                3
Alan Stern                             3
Cornelia Huck                          3
Jens Axboe                             3
Tejun Heo                              3



FS

Subject         : [NFSD OOPS] 2.6.23-rc1-git10
References      : http://lkml.org/lkml/2007/8/2/462
Last known good : ?
Submitter       : Andrew Clayton <andrew@digital-domain.net>
Caused-By       : ?
Handled-By      : ?
Status          : unknown



Kconfig

Subject         : CONFIG_HOTPLUG_CPU: kconfig bug?
References      : http://lkml.org/lkml/2007/8/27/204
Last known good : ?
Submitter       : Hugh Dickins <hugh@veritas.com>
Caused-By       : ?
Handled-By      : Sam Ravnborg <sam@ravnborg.org>
Status          : problem is being debugged



Networking

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
