Return-Path: <linux-kernel-owner+w=401wt.eu-S1763163AbXGPNNZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763163AbXGPNNZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 09:13:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756300AbXGPNNR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 09:13:17 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:60704 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755182AbXGPNNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 09:13:16 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: Patches for REALLY TINY 386 kernels
To: Satyam Sharma <satyam.sharma@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Jonathan Campbell <jon@nerdgrounds.com>, linux-kernel@vger.kernel.org
Reply-To: 7eggert@gmx.de
Date: Mon, 16 Jul 2007 15:12:54 +0200
References: <8HjYY-4Jk-15@gated-at.bofh.it> <8HlxM-7iT-13@gated-at.bofh.it> <8HlxL-7iT-11@gated-at.bofh.it> <8HlHq-7vR-17@gated-at.bofh.it> <8HlHr-7vR-25@gated-at.bofh.it>
User-Agent: KNode/0.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8Bit
Message-Id: <E1IAQNj-0006hB-2M@be1.lrz>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX19zlVeu40NOKDoABb0nqnTZM13LL97iHGaBFZt
 stkafoHfJzvY8IN3tlL43f6MZd5Ns7ta2fOq3aWDqbA3LiRPKk
 d5D2oLCylpmPZgq+IkgIg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Satyam Sharma <satyam.sharma@gmail.com> wrote:

[zillions of ways to do -X dontdiff]

> Or just "cp -al" to create multiple trees at (almost) no disk cost
> that won't interfere with each other in any way, and makes the
> development process / generating patchsets trifle easier as well ...

Beware, some editors do edit in-place. If you cp -rs "$PWD"/a b, you'll
at least spot those files you didn't copy before editing.
-- 
Top 100 things you don't want the sysadmin to say:
87. Sorry, the new equipment didn't get budgetted.

Friﬂ, Spammer: sun5@eE.7eggert.dyndns.org po@Tu1.7eggert.dyndns.org
