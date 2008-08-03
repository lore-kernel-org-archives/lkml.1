Return-Path: <linux-kernel-owner+w=401wt.eu-S1758503AbYHCR5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758503AbYHCR5j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 13:57:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751889AbYHCR5b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 13:57:31 -0400
Received: from 1wt.eu ([62.212.114.60]:2393 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751874AbYHCR5a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 13:57:30 -0400
Date: Sun, 3 Aug 2008 19:57:00 +0200
From: Willy Tarreau <w@1wt.eu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       ksummit-2008-discuss@lists.linux-foundation.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ide <linux-ide@vger.kernel.org>
Subject: Re: Kernel Summit request for Discussion of future of ATA (libata) and IDE
Message-ID: <20080803175700.GA22195@1wt.eu>
References: <1217779055.4179.10.camel@localhost.localdomain> <20080803173941.314edf33@lxorguk.ukuu.org.uk> <20080803173254.GI615@1wt.eu> <200808031945.04160.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808031945.04160.rjw@sisk.pl>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 03, 2008 at 07:45:03PM +0200, Rafael J. Wysocki wrote:
> > Anyway, in my experience, libata supports CF on embedded controllers
> > pretty well. So maybe we should start marking IDE drivers deprecated
> > to encourage people to try libata instead and report breakage if any.
> 
> Well, I know of at least one case of PC hardware in which an old IDE driver
> basically works while the libata/pata poeple have no idea why their driver
> doesn't:
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=9157

Interesting. I have a board with such a SIS controller somewhere here.
I'd have to shuffle the dust out of it and see if it still works, maybe
I can help on this one.

Regards,
Willy

