Return-Path: <linux-kernel-owner+w=401wt.eu-S1755388AbXJGS6w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388AbXJGS6w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 14:58:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752117AbXJGS6p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 14:58:45 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:58965 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120AbXJGS6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 14:58:44 -0400
Date: Sun, 7 Oct 2007 20:58:43 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Rene Herman <rene.herman@keyaccess.nl>
cc: Ingo Molnar <mingo@elte.hu>, Oleg Verych <olecom@flower.upol.cz>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>, Krzysztof Halasa <khc@pm.waw.pl>,
       Medve Emilian-EMMEDVE1 <Emilian.Medve@freescale.com>,
       Helge Deller <deller@gmx.de>
Subject: Re: "Re: [PATCH 0/2] Colored kernel output (run2)" + "`Subject:'
 usage"
In-Reply-To: <470929D8.80003@keyaccess.nl>
Message-ID: <Pine.LNX.4.64.0710072053300.16301@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0710062005190.5969@fbirervta.pbzchgretzou.qr>
 <20071006195105.GE22435@flower.upol.cz> <20071006194820.GA30579@elte.hu>
 <20071006210349.GG22435@flower.upol.cz> <20071007060706.GA18768@elte.hu>
 <20071007111035.GO22435@flower.upol.cz> <20071007161255.GA22102@elte.hu>
 <470929D8.80003@keyaccess.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 7 2007 20:47, Rene Herman wrote:
>
>> > Coloring isn't useful. If it was, it would be implemented ~16 years
>> > ago.
>> 
>> Congratulations, this is the most stupid argument i've ever read on lkml.
>
> "Ay. World is finished. Everyone can go home and watch Friends reruns now."
>
> But well, there actually have been worse arguments given that VGA console is
> getting less and less important.
>[...]
> Sure, that in itself needn't necesarily be of concern to anyone who, err, is
> not concerned but any such colouring feature appearing when there's only a
> smathering of people left that still cares about the VGA console in the first
> place really isn't all _that_ far out as an argument...

In case you have not noticed, the coloring also applies to FB.
As far as I can oversee, it's only "missing" for serial and PROMs.
