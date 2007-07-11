Return-Path: <linux-kernel-owner+w=401wt.eu-S1762058AbXGKJY1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762058AbXGKJY1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 05:24:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756244AbXGKJYS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 05:24:18 -0400
Received: from [84.243.56.243] ([84.243.56.243]:54677 "EHLO aurora.bayour.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1761543AbXGKJYP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 05:24:15 -0400
From: Turbo Fredriksson <turbo@bayour.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Moving MD/LVM from PPC to x86
Organization: Bah!
References: <87wsxneqs0.fsf@pumba.bayour.com>
	<20070629215416.GA12786@agk.fab.redhat.com>
	<876455erlw.fsf@pumba.bayour.com>
	<18054.9063.45466.586046@notabene.brown>
	<873azy4pq0.fsf@pumba.bayour.com>
	<18065.51428.849286.225118@notabene.brown>
X-PGP-Fingerprint: B7 92 93 0E 06 94 D6 22  98 1F 0B 5B FE 33 A1 0B
X-PGP-Key-ID: 0x788CD1A9
X-URL: http://www.bayour.com/
X-Yow: I've gotta GO, now!!  I wanta tell you you're a GREAT bunch of guys
 but you ought to CHANGE your UNDERWEAR more often!!
Date: Wed, 11 Jul 2007 11:24:11 +0200
In-Reply-To: <18065.51428.849286.225118@notabene.brown> (Neil Brown's message
	of "Mon, 9 Jul 2007 15:34:28 +1000")
Message-ID: <87644r1ef8.fsf@pumba.bayour.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Neil Brown <neilb@suse.de>:

>   3/ Once you are satisfied that things look right, use
>        mdadm --assemble /dev/md0 --update=byteorder ....
>     to assemble the array.

This worked. After a lot of tries. I kept getting 'resource busy'
(or 'device busy' or something other in that effect. But eventually
I got all my MD's moved.

Thanx for all the help.
-- 
Rule Psix Mossad class struggle tritium DES counter-intelligence
Treasury fissionable NORAD Kennedy smuggle genetic cracking subway
pits
[See http://www.aclu.org/echelonwatch/index.html for more about this]
[Or http://www.europarl.eu.int/tempcom/echelon/pdf/rapport_echelon_en.pdf]
If neither of these works, try http://www.aclu.org and search for echelon.
Note. This is a real, not fiction.
http://www.theregister.co.uk/2001/09/06/eu_releases_echelon_spying_report/
http://www.aclu.org/safefree/nsaspying/23989res20060131.html#echelon
