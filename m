Return-Path: <linux-kernel-owner+w=401wt.eu-S1760697AbXHTQCt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760697AbXHTQCt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 12:02:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760846AbXHTQCR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 12:02:17 -0400
Received: from wx-out-0506.google.com ([66.249.82.231]:26002 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760830AbXHTQCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 12:02:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=G3FZ+VMFY3Gzaw4qqFUlk3fVscTDAEunDg3b/fGSR1mY6LpNMAiynXtNAVQr5UCo9GXn6D/aWKTIEDNv7czrkWJGfVU4xeaSNuQJ8aHn+a3euufYwpNoDTSSAt2otUpOtazE8zC3mxb2XrbcfC6WC+TSS+/4jH6AhdmNH8sCLIY=
Message-ID: <46C9BAEF.9080605@googlemail.com>
Date: Mon, 20 Aug 2007 18:01:51 +0200
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
       Stephen Hemminger <shemminger@osdl.org>, Thomas Meyer <thomas@m3y3r.de>,
       Uwe Bugla <uwe.bugla@gmx.de>, Shish <shish@shishnet.org>,
       Karl Meyer <adhocrocker@gmail.com>,
       Francois Romieu <romieu@fr.zoreil.com>,
       Parag Warudkar <parag.warudkar@gmail.com>,
       Zachary Amsden <zach@vmware.com>
Subject: Re: [3/4] 2.6.23-rc3: known regressions v2
References: <46C9B6C7.5070704@googlemail.com>
In-Reply-To: <46C9B6C7.5070704@googlemail.com>
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
Cornelia Huck                          3
Jens Axboe                             3
Tejun Heo                              3



Networking

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



Virtualization

Subject         : CONFIG_VMI broken
References      : http://lkml.org/lkml/2007/8/14/203
Last known good : ?
Submitter       : Parag Warudkar <parag.warudkar@gmail.com>
Caused-By       : ?
Handled-By      : Zachary Amsden <zach@vmware.com>
Status          : problem is being debugged



Regards,
Michal

--
LOG
http://www.stardust.webpages.pl/log/
