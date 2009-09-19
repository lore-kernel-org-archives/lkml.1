Return-Path: <linux-kernel-owner+w=401wt.eu-S1757297AbZISPEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757297AbZISPEW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 11:04:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756552AbZISPEV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 11:04:21 -0400
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:51705 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756088AbZISPEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 11:04:20 -0400
Date: Sat, 19 Sep 2009 17:04:20 +0200
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Pavel Machek <pavel@ucw.cz>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Mattia Dongili <malattia@linux.it>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Matthias Welwarsky <matze@welwarsky.de>
Subject: Re: Linux not shutting down all devices? Battery drain in after
	shutdown
Message-ID: <20090919150420.GG20239@gamma.logic.tuwien.ac.at>
References: <20090917122451.GA13717@gandalf.dynalias.org> <20090919103709.GA4466@elf.ucw.cz> <20090919144911.GD28777@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090919144911.GD28777@khazad-dum.debian.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: Norbert Preining <preining@logic.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sa, 19 Sep 2009, Henrique de Moraes Holschuh wrote:
> I have seen this sort of problem on ThinkPads as well.  Lenovo decided to

Yes, Thinkpads are mentioned also in the thread I have cited. 

> fix it in firmware and shut down the stuff entirely in firmware.

Bad for us that Sony is not capable to do that.

> Interestingly enough, in the ThinkPad case, Windows was not affected.

It actually seems to depend on some settings/driver issues, that is the
reason why (I guess) Vista, XP, and linux all have these problems,
but not in all cases.

It is a bit frustrating though ...

Best wishes

Norbert

-------------------------------------------------------------------------------
Dr. Norbert Preining <preining@logic.at>        Vienna University of Technology
Debian Developer <preining@debian.org>                         Debian TeX Group
gpg DSA: 0x09C5B094      fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
-------------------------------------------------------------------------------
BABWORTH
Something which justifies having a really good cry.
			--- Douglas Adams, The Meaning of Liff
