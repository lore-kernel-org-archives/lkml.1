Return-Path: <linux-kernel-owner+w=401wt.eu-S1765439AbXJFVDr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765439AbXJFVDr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2007 17:03:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764218AbXJFVDk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Oct 2007 17:03:40 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:46992 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764116AbXJFVDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2007 17:03:39 -0400
Date: Sat, 6 Oct 2007 23:03:38 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Oleg Verych <olecom@flower.upol.cz>
cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>, Krzysztof Halasa <khc@pm.waw.pl>,
       Medve Emilian-EMMEDVE1 <Emilian.Medve@freescale.com>,
       Helge Deller <deller@gmx.de>
Subject: Re: [PATCH 0/2] Colored kernel output (run2)
In-Reply-To: <20071006210349.GG22435@flower.upol.cz>
Message-ID: <Pine.LNX.4.64.0710062300200.30354@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0710062005190.5969@fbirervta.pbzchgretzou.qr>
 <20071006195105.GE22435@flower.upol.cz> <20071006194820.GA30579@elte.hu>
 <20071006210349.GG22435@flower.upol.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 6 2007 23:03, Oleg Verych wrote:
>> 
>> (btw., i corrected the subject line to remove the 'NAK'. Why do you 
>> think you can 'NAK' a patch in this field?)
>
>I added comment (like this), so anyone can skip reading body, if headers
>are "Oleg Verych && NAK". In case if `NAK' have a magic meaning in the
>LKML, like control characters in the tty, i'm sorry.
>
>But how to express opinion quickly and easily?

You can't. I think that people will usually be interested _why_ you
voted for or against something (given the number of vote-submitters
does not go through the roof). That clearly won't fit into the subject,
and even if RFC822 allowed it, it's only displayed like 40 chars wide.
The submitter (me in this case) will even look at *all* mails, so as to
(1) address the NAKs and (2) address the hidden feature requests in
ACKs.  :-)
