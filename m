Return-Path: <linux-kernel-owner+w=401wt.eu-S1754772AbXGIMaR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772AbXGIMaR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 08:30:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752106AbXGIMaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 08:30:06 -0400
Received: from main.gmane.org ([80.91.229.2]:57919 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751905AbXGIMaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 08:30:04 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Oleg Verych (reduce the noise, read the list) 
	<for.gmane@flower.upol.cz>
Subject: Re: drop it ?(Re: [PATCH] fixup binutils printing from scripts/ver_linux)
Date: Mon, 9 Jul 2007 12:20:00 +0000 (UTC)
Organization: Palacky University in Olomouc, experimental physics department.
Message-ID: <slrnf94aoa.l6.for.gmane@flower.upol.cz>
References: <200707090147.58611.jesper.juhl@gmail.com> <20070709020606.GA5761@martell.zuzino.mipt.ru> <46919FD1.2060203@googlemail.com> <Pine.LNX.4.64.0707091241280.32335@fbirervta.pbzchgretzou.qr> <slrnf94817.l6.for.gmane@flower.upol.cz>
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: flower.upol.cz
User-Agent: slrn/0.9.8.1pl1 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Dumb, but better solution: drop that crap, called ver_linux.
> Know you have many distros, so be happy with any one, and forget about
> black old days of finding toolchain, that can actually build the kernel.

#v+
echo 'If some fields are empty or look unusual you may have an old version.'
echo 'Compare to the current minimal requirements in Documentation/Changes.'
echo ' '
#v-

The comment above is yet another cause to remind you to check `reportbug`
tool and how it organizes collecting of information for particular bug
report and package.
____

