Return-Path: <linux-kernel-owner+w=401wt.eu-S1030325AbXDQOpv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030325AbXDQOpv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 10:45:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030419AbXDQOpv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 10:45:51 -0400
Received: from [81.2.110.250] ([81.2.110.250]:59308 "EHLO the-village.bc.nu"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030325AbXDQOpu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 10:45:50 -0400
Date: Tue, 17 Apr 2007 15:48:14 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tomasz =?UTF-8?B?S8WCb2N6a28=?= <kloczek@rudy.mif.pg.gda.pl>
Cc: Theodore Tso <tytso@mit.edu>, "David R. Litwin" <presently42@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: ZFS with Linux: An Open Plea
Message-ID: <20070417154814.632da1d9@the-village.bc.nu>
In-Reply-To: <Pine.BSO.4.63.0704171527150.11088@rudy.mif.pg.gda.pl>
References: <op.tqw1g6n0ftfxs2@localhost.localdomain>
	<20070417131045.GB18373@thunk.org>
	<Pine.BSO.4.63.0704171527150.11088@rudy.mif.pg.gda.pl>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> So who is responsible for potential changing Linux code licensing for 
> allow if not incorporate CDDL code correct interraction without breaking 
> some law ?

Every single contributor, individually. Which won't happen.

The real test of whether Sun were serious about ZFS being anywhere but
Solaris is what they do to license it - they've patented everything they
can, and made the code available only under licenses incompatible with
other OS products. Their intent is quite clear, and quite sad.

Compare it to what the old Sun company did with NFS, which is now a
standard used everywhere.

If Sun want ZFS to get used all over the place in free software then I'd
have expected at the very least to see them throw out a copy of the code,
docs and patent grant in a form that could be used, even if it came with
no other assistance of any kind. Now would be a great time to do that,
but I can't see it happening, instead they'll miss the boat just as
microsoft did with Office XML (three years ago they'd have sailed it
through ISO to the sound of fanfairs)

Alan
