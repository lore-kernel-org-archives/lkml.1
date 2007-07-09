Return-Path: <linux-kernel-owner+w=401wt.eu-S1755234AbXGIKmH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234AbXGIKmH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 06:42:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751601AbXGIKlz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 06:41:55 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:7312 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315AbXGIKlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 06:41:55 -0400
Date: Mon, 9 Jul 2007 12:41:54 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Gabriel C <nix.or.die@googlemail.com>
cc: Alexey Dobriyan <adobriyan@gmail.com>, Jesper Juhl <jesper.juhl@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       sam@ravenborg.org
Subject: Re: [PATCH] fixup binutils printing from scripts/ver_linux
In-Reply-To: <46919FD1.2060203@googlemail.com>
Message-ID: <Pine.LNX.4.64.0707091241280.32335@fbirervta.pbzchgretzou.qr>
References: <200707090147.58611.jesper.juhl@gmail.com>
 <20070709020606.GA5761@martell.zuzino.mipt.ru> <46919FD1.2060203@googlemail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 9 2007 04:39, Gabriel C wrote:
>>
>> NAK. It starts reporting here empty binutils field.
>> FWIW,
>>
>>  $ ld -v
>>  GNU ld version 2.16.1
>>
>
> Well the format changed so now we have :
>
> $ ld -v
> GNU ld (Linux/GNU Binutils) 2.17.50.0.16.20070511

Adding to the collection:
12:39 ichi:~ > ld -v
GNU ld version 2.17.50.0.5 20060927 (SUSE Linux)


	Jan
-- 
