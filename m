Return-Path: <linux-kernel-owner+w=401wt.eu-S933485AbXBEVhr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933485AbXBEVhr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 16:37:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933484AbXBEVhq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 16:37:46 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:47333 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933480AbXBEVhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 16:37:45 -0500
Date: Mon, 5 Feb 2007 21:50:07 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] MTD: fix DOC2000/2001/2001PLUS build error
Message-ID: <20070205215007.0820edea@localhost.localdomain>
In-Reply-To: <1170710272.29759.894.camel@pmac.infradead.org>
References: <Pine.LNX.4.64.0702041057090.8424@woody.linux-foundation.org>
	<20070205084523.GA21858@elte.hu>
	<1170682488.29759.795.camel@pmac.infradead.org>
	<20070205155627.GA8354@elte.hu>
	<1170692539.29759.856.camel@pmac.infradead.org>
	<20070205162635.GA755@elte.hu>
	<20070205163152.GA2464@elte.hu>
	<Pine.LNX.4.64.0702050852160.8424@woody.linux-foundation.org>
	<1170710272.29759.894.camel@pmac.infradead.org>
X-Mailer: Claws Mail 2.7.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> No, you're thinking of something else. The use of 'select' just turns
> the problem backwards -- if _every_ SCSI hostadapter were to 'select
> SCSI' instead of depending on it, then I'd have to say 'n' to every damn
> one of them instead of being able to just say 'n' to SCSI as I can at
> the moment.

Tools issue. You want a "really de-select right now" button 

Alan
