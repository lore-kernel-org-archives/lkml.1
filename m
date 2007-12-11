Return-Path: <linux-kernel-owner+w=401wt.eu-S1756394AbXLKRDZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756394AbXLKRDZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 12:03:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756015AbXLKRCi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 12:02:38 -0500
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:36774 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756002AbXLKRCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 12:02:37 -0500
Message-ID: <475EC24E.2000808@keyaccess.nl>
Date: Tue, 11 Dec 2007 18:01:02 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: "David P. Reed" <dpreed@reed.com>
CC: Paul Rolland <rol@as2917.net>, David Newall <david@davidnewall.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Krzysztof Halasa <khc@pm.waw.pl>,
       Pavel Machek <pavel@ucw.cz>, Andi Kleen <andi@firstfloor.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       rol@witbe.net
Subject: Re: RFC: outb 0x80 in inb_p, outb_p harmful on some modern AMD64
 with MCP51 laptops
References: <475879CD.9080006@reed.com>	<p733auekcly.fsf@bingen.suse.de>	<20071207160439.71b7f46a@the-village.bc.nu>	<20071209125458.GB4381@ucw.cz>	<20071209165908.GA15910@one.firstfloor.org>	<20071209212513.GC24284@elf.ucw.cz>	<475CBDD7.5050602@keyaccess.nl>	<m3bq8y23de.fsf@maximus.localdomain>	<475DE37F.20706@davidnewall.com>	<475DE6F4.80702@zytor.com>	<475DEB23.1000304@davidnewall.com>	<20071211084059.3d03e11d@tux.DEF.witbe.net>	<475E5D4B.8020101@keyaccess.nl>	<475E7DC2.4060509@davidnewall.com>	<475E8D91.20201@keyaccess.nl>	<20071211143224.15900995@tux.DEF.witbe.net>	<475E9B9B.2050709@keyaccess.nl>	<475EACB8.7080608@keyaccess.nl> <20071211163706.2dc82275@tux.DEF.witbe.net> <475EB263.2050405@keyaccess.nl> <475EC1C0.2040000@reed.com>
In-Reply-To: <475EC1C0.2040000@reed.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-12-07 17:58, David P. Reed wrote:

> I do remind all that 0x80 is a BIOS-specific standard, and is per BIOS

There's lots of things concerning the PC that is documented nowhere and is 
still true. Did you test 0xed?

Rene.
