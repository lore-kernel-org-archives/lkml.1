Return-Path: <linux-kernel-owner+w=401wt.eu-S1762517AbXEUKmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762517AbXEUKmR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 06:42:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755966AbXEUKmD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 06:42:03 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:25966 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754545AbXEUKmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 06:42:01 -0400
Date: Mon, 21 May 2007 12:41:58 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: "Denver Gingerich" <denver@ossguy.com>
Cc: linux-kernel@vger.kernel.org, Greg K-H <greg@kroah.com>
Subject: Re: [PATCH] fix compiler warning in dd.c
Message-ID: <20070521124158.6503862b@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <6defe8840705201936s7c011750w5bd4613b33eb9c70@mail.gmail.com>
References: <6defe8840705091829h44b78dc2w44f07c0993469128@mail.gmail.com>
	<6defe8840705201936s7c011750w5bd4613b33eb9c70@mail.gmail.com>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.12; i486-pc-linux-gnu)
X-Legal: IBM Deutschland Entwicklung GmbH Vorsitzender des Aufsichtsrats:
 Johann Weihen =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Herbert Kircher Sitz
 der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 May 2007 22:36:48 -0400,
"Denver Gingerich" <denver@ossguy.com> wrote:

> This patch had been suggested by Indan Zupancic on May 13 but is not
> in 2.6.22-rc2 so I'm re-sending it.  Prior to Indan's e-mail, I had
> sent the same patch to the kernel janitors list.  I don't care whether
> you credit the patch to me or Indan.

It seems you're about the fourth person to send that patch ;)

(Greg has driver-core-kill-unused-code.patch sitting in his tree, so I
guess he'll send this with his next round of patches.)
