Return-Path: <linux-kernel-owner+w=401wt.eu-S1161310AbXCNOgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161310AbXCNOgu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 10:36:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161306AbXCNOgn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 10:36:43 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:40311 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161304AbXCNOgm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 10:36:42 -0400
Message-ID: <45F80871.4040200@gmail.com>
Date: Wed, 14 Mar 2007 15:36:33 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0b2 (X11/20070116)
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org, vortex@scyld.com
Subject: Re: 3c59x regression (transmission stop)
References: <45F7EB9C.3070208@gmail.com>
In-Reply-To: <45F7EB9C.3070208@gmail.com>
X-Enigmail-Version: 0.95b
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Muni-Spam-TestIP: 147.251.48.3
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Wed, 14 Mar 2007 15:36:36 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby napsal(a):
> There is nothing significant in dmesg, 2.6.17-rc5 was fine, so this is
> definitely a regression.

No, it's probably not, it allegedly happened sometimes in 2.6.17-rc5 too,
I've changed the card.

regards,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
