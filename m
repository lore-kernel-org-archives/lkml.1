Return-Path: <linux-kernel-owner+w=401wt.eu-S1756558AbXGIJs6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756558AbXGIJs6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 05:48:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752443AbXGIJsv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 05:48:51 -0400
Received: from [84.243.56.243] ([84.243.56.243]:46814 "EHLO aurora.bayour.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752301AbXGIJsu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 05:48:50 -0400
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
X-Yow: I'm into SOFTWARE!
Date: Mon, 09 Jul 2007 11:48:46 +0200
In-Reply-To: <18065.51428.849286.225118@notabene.brown> (Neil Brown's message
	of "Mon, 9 Jul 2007 15:34:28 +1000")
Message-ID: <87r6nh3o1t.fsf@pumba.bayour.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Neil Brown <neilb@suse.de>:

> This suggests that the superblock is currently the correct byteorder
> for the current host.  You use
>    mdadm --examine --metadata=0.swap /dev/sda1
> when you have moved a devices from one host to different host with the
> opposite endian-ness (e.g. bigendian to littlendian).

I see, thanx for clarifying this.

> Does that make it clear?

Absolutely. I just want to be very clear. I don't have a full backup
(have no means to backup 1Tb), so I want to minimize the risk of loosing
data. I thank you for explaining so that even I can understand :)




PS. No sarcasm intended, even IF it should sound like it! I _am_ greatfull.
-- 
Noriega Honduras Marxist South Africa president AK-47 FSF radar FBI
congress class struggle SEAL Team 6 colonel Cocaine DES
[See http://www.aclu.org/echelonwatch/index.html for more about this]
[Or http://www.europarl.eu.int/tempcom/echelon/pdf/rapport_echelon_en.pdf]
If neither of these works, try http://www.aclu.org and search for echelon.
Note. This is a real, not fiction.
http://www.theregister.co.uk/2001/09/06/eu_releases_echelon_spying_report/
http://www.aclu.org/safefree/nsaspying/23989res20060131.html#echelon
