Return-Path: <linux-kernel-owner+w=401wt.eu-S1756652AbXEUXvc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652AbXEUXvc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 19:51:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754953AbXEUXvZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 19:51:25 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37348 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754914AbXEUXvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 19:51:24 -0400
Date: Mon, 21 May 2007 16:38:56 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
cc: Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       stable@kernel.org, Tejun Heo <htejun@gmail.com>,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alan Cox <alan@redhat.com>
Subject: Re: [patch 07/69] libata-sff: Undo bug introduced with pci_iomap
 changes
In-Reply-To: <46522C37.1020404@garzik.org>
Message-ID: <alpine.LFD.0.98.0705211638070.3890@woody.linux-foundation.org>
References: <20070521191612.800400000@sous-sol.org> <20070521191701.791285000@sous-sol.org>
 <alpine.LFD.0.98.0705211614210.3890@woody.linux-foundation.org>
 <46522C37.1020404@garzik.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 21 May 2007, Jeff Garzik wrote:
> > And no, I do not think it's languishing in my mailqueue. I'm pretty sure
> > it's languishing somewhere else. 
> 
> AFAIK it was obsoleted by another Tejun patch which -is- upstream.
> 
> Am I missing something?

Ahh, in that case it should hopefully be noted as such. I just got worried 
when I saw Chris' note.

		Linus
