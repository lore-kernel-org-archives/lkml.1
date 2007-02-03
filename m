Return-Path: <linux-kernel-owner+w=401wt.eu-S1751325AbXBCTf5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751325AbXBCTf5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 14:35:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751315AbXBCTf5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 14:35:57 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:55101 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751325AbXBCTfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 14:35:55 -0500
Date: Sat, 3 Feb 2007 19:47:35 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: Bodo Eggert <7eggert@gmx.de>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>, Bodo Eggert <7eggert@gmx.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Jon Masters <jonathan@jonmasters.org>,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH/RFC] alternative aproach to: Ban module license tag
 string termination trick
Message-ID: <20070203194735.02441493@localhost.localdomain>
In-Reply-To: <Pine.LNX.4.58.0702031350360.2384@be1.lrz>
References: <Pine.LNX.4.58.0702022216120.25199@be1.lrz>
	<Pine.LNX.4.61.0702031213220.27840@yvahk01.tjqt.qr>
	<Pine.LNX.4.58.0702031350360.2384@be1.lrz>
X-Mailer: Claws Mail 2.7.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> ACK, and "BSD" etc. should be included. I kept the combinations for 
> backward-compatibility. Possibly we could warn on using them.

BSD is intentionally not allowed. Any proprietary vendor can decide their
code is BSD and never release source just let people play with the
binary. That is why we enforce at least dual.

