Return-Path: <linux-kernel-owner+w=401wt.eu-S1753257AbXCMN3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257AbXCMN3A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 09:29:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753254AbXCMN3A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 09:29:00 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:21852 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753257AbXCMN3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 09:29:00 -0400
Date: Tue, 13 Mar 2007 14:30:34 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Adrian Bunk <bunk@stusta.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>, Marcel Holtmann <marcel@holtmann.org>,
       maxk@qualcomm.com, bluez-devel@lists.sourceforge.net,
       Mark Lord <lkml@rtr.ca>
Subject: Re: [2/6] 2.6.21-rc3: known regressions
Message-ID: <20070313143034.77425af4@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070313125003.GS18731@stusta.de>
References: <Pine.LNX.4.64.0703062050570.5963@woody.linux-foundation.org>
	<20070313125003.GS18731@stusta.de>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.8.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
X-Legal: IBM Deutschland Entwicklung GmbH Vorsitzender des Aufsichtsrats:
 Johann Weihen =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Herbert Kircher Sitz
 der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Mar 2007 13:50:03 +0100,
Adrian Bunk <bunk@stusta.de> wrote:

> Subject    : ThinkPad X60: bluetooth hardlocks
> References : http://lkml.org/lkml/2007/3/2/85
> Submitter  : Pavel Machek <pavel@ucw.cz>
> Handled-By : Marcel Holtmann <marcel@holtmann.org>
> Status     : unknown

Does this still happen with -rc3? I'd have thought Mark's patch in
0de1517e23c2e28d58a6344b97a120596ea200bb fixed that...
