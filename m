Return-Path: <linux-kernel-owner+w=401wt.eu-S1753001AbXJGInN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001AbXJGInN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 04:43:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752079AbXJGIm7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 04:42:59 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:33041 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045AbXJGIm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 04:42:58 -0400
Date: Sun, 7 Oct 2007 10:42:57 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Bill Davidsen <davidsen@tmr.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>
Subject: Re: [PATCH] Cute feature: colored printk output
In-Reply-To: <47082D3D.5090101@tmr.com>
Message-ID: <Pine.LNX.4.64.0710071039550.30354@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0710052111340.13406@fbirervta.pbzchgretzou.qr>
 <4707E7C9.8010501@tmr.com> <Pine.LNX.4.64.0710062158190.20637@fbirervta.pbzchgretzou.qr>
 <47082D3D.5090101@tmr.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 6 2007 20:50, Bill Davidsen wrote:
>> 
>>> I start my root xterm in white on blue for identification, so color coding
>>> sounds like a great idea to me.
>> 
>> This has nothing to do with xterms, this is "VGA color console" only.
>> xterm config is in /usr/share/X11/app-defaults/XTerm-color.
>
> Try reparsing that... I said I use color coding in root xterm, so I am
> generally in favor of the color coding concept to make important messages
> obvious. Is that clearer?

A reparse did it.
