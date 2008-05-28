Return-Path: <linux-kernel-owner+w=401wt.eu-S1753035AbYE1RsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753035AbYE1RsR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 13:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751940AbYE1RsG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 13:48:06 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:56731 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910AbYE1RsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 13:48:05 -0400
Date: Wed, 28 May 2008 19:48:03 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Dave Jones <davej@redhat.com>
cc: Linux Kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [X86] Fix up silly i1586 boot message.
In-Reply-To: <20080528165713.GA412@redhat.com>
Message-ID: <alpine.LNX.1.10.0805281943330.19264@fbirervta.pbzchgretzou.qr>
References: <20080528165713.GA412@redhat.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wednesday 2008-05-28 18:57, Dave Jones wrote:

>Trying to boot a 64-bit kernel on a 32bit Pentium 4 gets
>you an amusing message along the lines of.
>"you need an x86-64, but you only have an i1586"
>due to the P4 being family F.  Munge it to be 686.

What is wrong with it? If i386, 486, 586 and 686 are valid names,
why should not 786 (or rather 1586... since someone thought it
would be cool to jump the number^1) be?


[^1 Which also is interesting because the original number had an 80
prepended, i.e. 80286, 80586,... and you'd guess what number 1586
would map to.]
