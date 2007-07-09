Return-Path: <linux-kernel-owner+w=401wt.eu-S1757833AbXGILka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757833AbXGILka (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 07:40:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754221AbXGILkN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 07:40:13 -0400
Received: from main.gmane.org ([80.91.229.2]:38414 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754479AbXGILkM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 07:40:12 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Oleg Verych (olecom) <no.copies@flower.upol.cz>
Subject: drop it ?(Re: [PATCH] fixup binutils printing from scripts/ver_linux)
Date: Mon, 9 Jul 2007 11:33:33 +0000 (UTC)
Organization: Palacky University in Olomouc, experimental physics department.
Message-ID: <slrnf94817.l6.for.gmane@flower.upol.cz>
References: <200707090147.58611.jesper.juhl@gmail.com> <20070709020606.GA5761@martell.zuzino.mipt.ru> <46919FD1.2060203@googlemail.com> <Pine.LNX.4.64.0707091241280.32335@fbirervta.pbzchgretzou.qr>
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: flower.upol.cz
User-Agent: slrn/0.9.8.1pl1 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Jan Engelhardt "Mon, 9 Jul 2007 12:41:54 +0200 (CEST)"
>
> On Jul 9 2007 04:39, Gabriel C wrote:
>>>
>>> NAK. It starts reporting here empty binutils field.
>>> FWIW,
>>>
>>>  $ ld -v
>>>  GNU ld version 2.16.1
>>>
>>
>> Well the format changed so now we have :
>>
>> $ ld -v
>> GNU ld (Linux/GNU Binutils) 2.17.50.0.16.20070511
>
> Adding to the collection:
> 12:39 ichi:~ > ld -v
> GNU ld version 2.17.50.0.5 20060927 (SUSE Linux)

Dumb, but better solution: drop that crap, called ver_linux.
Know you have many distros, so be happy with any one, and forget about
black old days of finding toolchain, that can actually build the kernel.

Anything else is a Foo Linux Distribution's Problem (tm)
____

