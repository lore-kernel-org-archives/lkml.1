Return-Path: <linux-kernel-owner+w=401wt.eu-S1757188AbYGNJTw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757188AbYGNJTw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 05:19:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755637AbYGNJTo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 05:19:44 -0400
Received: from mxl.seznam.cz ([77.75.72.44]:56744 "EHLO mxl.seznam.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862AbYGNJTo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 05:19:44 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=beta; d=seznam.cz;
	h=Received:Message-ID:Date:From:Reply-To:User-Agent:MIME-Version:To:Subject:Content-Type:Content-Transfer-Encoding:X-Smtpd:X-Seznam-User:X-QM-Mark;
	b=bvsSZWn8HgcGFDRY6z2nDNYJ80ZrHhPZU+9czjVOaouHbr+k7v4v6qtq4Nyo2aDSW
	LO9nBiXmTbLEHoRCvC781EsvYLGVxNojOfqbJ540VVdB+4gcRkM3OEs89+/8eoeHH7M
	O5yWCgbqNB6XHp7+rsngHAZrv4HlBjdqxc29XC0=
Message-ID: <487B19E0.3030301@seznam.cz>
Date: Mon, 14 Jul 2008 11:18:24 +0200
From: Michal Simek <monstr@seznam.cz>
Reply-To: linux-arch@vger.kernel.org
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Linux Kernel list <linux-kernel@vger.kernel.org>,
       torvalds@linux-foundation.org,
       John Williams <john.williams@petalogix.com>,
       Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>,
       John Linn <John.Linn@xilinx.com>, Jon Loeliger <jdl@jdl.com>,
       David Gibson <david@gibson.dropbear.id.au>,
       Arnd Bergmann <arnd@arndb.de>, Sam Ravnborg <sam@ravnborg.org>
Subject: Microblaze architecture - ACK
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
X-Smtpd: 1.1.2@13384
X-Seznam-User: monstr@seznam.cz
X-QM-Mark: email-qm2<199205027>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

as you know I do linux for Microblaze and this is the right time to got some
ACK from community. I looked at Linus tree and 2.6.26 has been released and it
is the right time for Microblaze.

I have got ACK from John Williams (Petalogix.com) who starts with linux for
microblaze and Steve Neuendorffer from Xilinx (Xilinx is manufacturer of
Microblaze CPU).

I would like to got some ACK from people which are not directly connected with
Microblaze and who are interested in parts of linux.

I have sent some request to people who I know:
Jon Loeliger and David Gibson for ACK on generic DTS structure
Sam Ravnborg for Kconfig and Makefile ACK

Arnd: I hope you know much about microblaze. Could you help me with the last
stage of merging?

Could you recommend me people who can give me valuable ACK? (I'll send patches
to them and then full pack to LKML too).

Thanks for your help,
Michal Simek


