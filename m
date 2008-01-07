Return-Path: <linux-kernel-owner+w=401wt.eu-S1760053AbYAGVes@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760053AbYAGVes (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 16:34:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758867AbYAGVel
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 16:34:41 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:47634 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757725AbYAGVej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 16:34:39 -0500
Date: Mon, 7 Jan 2008 21:31:56 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Valdis.Kletnieks@vt.edu
Cc: Willy Tarreau <w@1wt.eu>, Adrian Bunk <bunk@kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Matthew Wilcox <matthew@wil.cx>, Ingo Molnar <mingo@elte.hu>,
       Peter Osterlund <petero2@telia.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [patch] scsi: revert "[SCSI] Get rid of scsi_cmnd->done"
Message-ID: <20080107213156.0bd5e9f1@lxorguk.ukuu.org.uk>
In-Reply-To: <19438.1199739038@turing-police.cc.vt.edu>
References: <m3ir27oe7f.fsf@telia.com>
	<1199627875.5205.1.camel@localhost.localdomain>
	<20080106144706.GA25419@elte.hu>
	<1199632845.5205.31.camel@localhost.localdomain>
	<20080106171158.GM20473@parisc-linux.org>
	<1199640983.5205.65.camel@localhost.localdomain>
	<20080106183402.GA7906@1wt.eu>
	<20080106185625.GM2082@does.not.exist>
	<20080106191044.GA1105@1wt.eu>
	<20080106195802.GN2082@does.not.exist>
	<20080106210813.GA10136@1wt.eu>
	<19438.1199739038@turing-police.cc.vt.edu>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Personally, I've lost count of the number of times I've *not* reported a
> bug/oops just because of the "NVidia users this means you" statement, only
> to have the exact same issue reported several weeks/months later by somebody
> who's able to replicate it with an untainted kernel.

And I've lost count of the number of bugs reported that turned out to be
the Nvidia modules.

Alan
