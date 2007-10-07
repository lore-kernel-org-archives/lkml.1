Return-Path: <linux-kernel-owner+w=401wt.eu-S1756746AbXJGUDO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756746AbXJGUDO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 16:03:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755853AbXJGUC6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 16:02:58 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:37242 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755826AbXJGUC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 16:02:58 -0400
Date: Sun, 7 Oct 2007 22:02:56 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Rene Herman <rene.herman@keyaccess.nl>
cc: Ingo Molnar <mingo@elte.hu>, Oleg Verych <olecom@flower.upol.cz>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>, Krzysztof Halasa <khc@pm.waw.pl>,
       Medve Emilian-EMMEDVE1 <Emilian.Medve@freescale.com>,
       Helge Deller <deller@gmx.de>
Subject: Re: "Re: [PATCH 0/2] Colored kernel output (run2)" + "`Subject:'
 usage"
In-Reply-To: <47093322.1030200@keyaccess.nl>
Message-ID: <Pine.LNX.4.64.0710072157170.16301@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0710062005190.5969@fbirervta.pbzchgretzou.qr>
 <20071006195105.GE22435@flower.upol.cz> <20071006194820.GA30579@elte.hu>
 <20071006210349.GG22435@flower.upol.cz> <20071007060706.GA18768@elte.hu>
 <20071007111035.GO22435@flower.upol.cz> <20071007161255.GA22102@elte.hu>
 <470929D8.80003@keyaccess.nl> <Pine.LNX.4.64.0710072053300.16301@fbirervta.pbzchgretzou.qr>
 <47093322.1030200@keyaccess.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 7 2007 21:27, Rene Herman wrote:
>
> I saw you remark on FB console in a reply to Alan just now and I
> quite agree with you. The (current) FB console is slow and I'll add
> "dumb" myself. When you have a 1280x1024 screen available, you get
> to do cool things like put up nice little windows and exclamation
> mark icons on errors, not just pretend you're really 132x50 (or
> whatever).

CVIDIX, while card-dependent I think, is much better at speed than FB
while still providing 720x400 or even higher.
