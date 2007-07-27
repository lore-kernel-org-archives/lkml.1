Return-Path: <linux-kernel-owner+w=401wt.eu-S1765377AbXG0U5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765377AbXG0U5k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 16:57:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937768AbXG0U4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 16:56:15 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:20943 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936387AbXG0U4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 16:56:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=gZ2VN6izsQIO/zAid/L/Pv8Cga5DlJac/n8YNTRXJluhFiz96DfDfJ0raU7bp1jhzn9OS1bftv/JOYQENKK0w56Z1ePZyvPGxNi6T8nYBac1Vmv5yF6Z1l99VvowyfbZhzTqIzxsjSMc9zip+60bs4bLAu0Rx0tHcAC87iw/Vys=
Message-ID: <46AA5B39.2010209@googlemail.com>
Date: Fri, 27 Jul 2007 22:53:13 +0200
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Eric Sesterhenn <snakebyte@gmx.de>,
       Sid Boyce <g3vbv@blueyonder.co.uk>, linux-ide@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, dth <dth@dth.net>,
       Netdev <netdev@vger.kernel.org>,
       Stephen Hemminger <shemminger@osdl.org>, Thomas Meyer <thomas@m3y3r.de>,
       Florian Lohoff <flo@rfc822.org>
Subject: Re: [2/3] 2.6.23-rc1: known regressions v2
References: <46AA581D.6080100@googlemail.com>
In-Reply-To: <46AA581D.6080100@googlemail.com>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
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



Unclassified

Subject         : 2.6.23-rc1-git3 init failure
References      : http://lkml.org/lkml/2007/7/26/467
Last known good : ?
Submitter       : Sid Boyce <g3vbv@blueyonder.co.uk>
Caused-By       : ?
Handled-By      : ?
Status          : unknown

Subject         : Time Problems with 2.6.23-rc1-gf695baf2
References      : http://lkml.org/lkml/2007/7/23/486
Last known good : ?
Submitter       : Eric Sesterhenn <snakebyte@gmx.de>
Caused-By       : ?
Handled-By      : ?
Status          : problem is being debugged



IDE

Subject         : ide problems: 2.6.22-git17 working, 2.6.23-rc1* is not
References      : http://lkml.org/lkml/2007/7/27/298
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



Regards,
Michal

--
LOG
http://www.stardust.webpages.pl/log/
