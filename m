Return-Path: <linux-kernel-owner+w=401wt.eu-S1755983AbXLKUf5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983AbXLKUf5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 15:35:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752636AbXLKUft
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 15:35:49 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:63497 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785AbXLKUfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 15:35:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:from;
        b=YXE/uI6tdreY592T2XieAlEm0RkmImU7FHQavtBWLvO1kMgppEsbTl/l8Hku26Lu8mkG+pBDkFLs/HJz+eZnHF7akOfD9kJYiGC8DzLKhhlvtreJy5dWy1DBfW5Cv30rlSiCgMQ2O2EhWCmTqhLaL/3vODesTPR306dWT2p6U7Y=
Message-ID: <475EF44D.5050007@keyaccess.nl>
Date: Tue, 11 Dec 2007 21:34:21 +0100
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
CC: "David P. Reed" <dpreed@reed.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Paul Rolland <rol@as2917.net>, David Newall <david@davidnewall.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Krzysztof Halasa <khc@pm.waw.pl>,
       Pavel Machek <pavel@ucw.cz>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, rol@witbe.net
Subject: Re: RFC: outb 0x80 in inb_p, outb_p harmful on some modern AMD64
 with MCP51 laptops
References: <475879CD.9080006@reed.com> <p733auekcly.fsf@bingen.suse.de> <20071207160439.71b7f46a@the-village.bc.nu> <20071209125458.GB4381@ucw.cz> <20071209165908.GA15910@one.firstfloor.org> <20071209212513.GC24284@elf.ucw.cz> <475CBDD7.5050602@keyaccess.nl> <m3bq8y23de.fsf@maximus.localdomain> <475DE37F.20706@davidnewall.com> <475DE6F4.80702@zytor.com> <475DEB23.1000304@davidnewall.com> <20071211084059.3d03e11d@tux.DEF.witbe.net> <475E5D4B.8020101@keyaccess.nl> <475E7DC2.4060509@davidnewall.com> <475E8D91.20201@keyaccess.nl> <20071211143224.15900995@tux.DEF.witbe.net> <475E9B9B.2050709@keyaccess.nl> <475EACB8.7080608@keyaccess.nl> <20071211163706.2dc82275@tux.DEF.witbe.net> <475EB263.2050405@keyaccess.nl> <475EC1C0.2040000@reed.com> <20071211173231.2b87a81f@the-village.bc.nu> <475EE2CA.6020601@reed.com> <Pine.LNX.4.61.0712111513490.23653@chaos.analogic.com>
In-Reply-To: <Pine.LNX.4.61.0712111513490.23653@chaos.analogic.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
From: Rene Herman <rene.herman@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-12-07 21:27, linux-os (Dick Johnson) wrote:

> I didn't know you worked in Boca Raton for Don Estrage on
> the IBM 5150. I must have missed you --somehow.

Frankly, if there ever was a good reason for _not_ merging i386 and x86-64 
it would've been having an escape from these kinds of discussions...

Rene.
