Return-Path: <linux-kernel-owner+w=401wt.eu-S1753136Ab0AYUvn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136Ab0AYUvn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 15:51:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752912Ab0AYUvm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 15:51:42 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:51905 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752707Ab0AYUvl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 15:51:41 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Dimitrios Apostolou <jimis@gmx.net>
Subject: Re: [Bug #15040] High cpu temperature with 2.6.32
Date: Mon, 25 Jan 2010 21:52:32 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc4-rjw; KDE/4.3.3; x86_64; ; )
Cc: Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <pYFNu11z2aM.A.pJH.CZMXLB@chimera> <q60Z28d_9yH.A.bxH.PZMXLB@chimera> <alpine.LNX.2.00.1001250115420.6323@localhost.localdomain>
In-Reply-To: <alpine.LNX.2.00.1001250115420.6323@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001252152.33031.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 25 January 2010, Dimitrios Apostolou wrote:
> I will let you know when this bug is fixed in a regular kernel release. I 
> just tested 2.6.32.5 and the bug persists. BTW, Arjan, I think this bug 
> will be biting other people too, see the following thread: 
> http://bugs.archlinux.org/task/17771

I don't think it's fixed, I haven't seen the Arjan's patch anywhere close to
the mainline.

Arjan, perhaps send it directly to Linus, please (unless it's already waiting
somewhere for merging)?

Rafael
