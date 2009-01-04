Return-Path: <linux-kernel-owner+w=401wt.eu-S932996AbZADASZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932996AbZADASZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 19:18:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760084AbZADASO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 19:18:14 -0500
Received: from casper.infradead.org ([85.118.1.10]:36031 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684AbZADASN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 19:18:13 -0500
Date: Sat, 3 Jan 2009 16:20:00 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Robert Hancock <hancockr@shaw.ca>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, x86@kernel.org, netdev@vger.kernel.org,
       tytso@mit.edu, eric@anholt.net, airlied@redhat.com
Subject: Re: Bug/Warning report for the week of January 3rd, 2009
Message-ID: <20090103162000.138943b3@infradead.org>
In-Reply-To: <495FF769.3040205@shaw.ca>
References: <20090103140332.74f39ade@infradead.org>
	<495FF769.3040205@shaw.ca>
Organization: Intel
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 03 Jan 2009 17:40:25 -0600
Robert Hancock <hancockr@shaw.ca> wrote:

> Arjan van de Ven wrote:
> > Rank 2: mtrr_trim_uncached_memory (warning)
> > 	Reported 420 times (9816 total reports)
> > 	BIOS bug (often in VMWare) where the MTRR's are set up
> > incorrectly or not at all This warning was last seen in version
> > 2.6.28, and first seen in 2.6.24. More info:
> > http://www.kerneloops.org/searchweek.php?search=mtrr_trim_uncached_memory
> 
> It would be useful if this warning dumped out some DMI BIOS
> information or something, so we could see what systems/boards this
> was commonly happening with.. 

yes it would; this is why Linus merged a patch to do exactly that for
2.6.29..........



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
