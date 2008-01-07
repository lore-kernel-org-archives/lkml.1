Return-Path: <linux-kernel-owner+w=401wt.eu-S1760209AbYAGVhb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760209AbYAGVhb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 16:37:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750954AbYAGVhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 16:37:20 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:42928 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766AbYAGVhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 16:37:19 -0500
Date: Mon, 7 Jan 2008 14:37:17 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Valdis.Kletnieks@vt.edu
Cc: Willy Tarreau <w@1wt.eu>, Adrian Bunk <bunk@kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Osterlund <petero2@telia.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [patch] scsi: revert "[SCSI] Get rid of scsi_cmnd->done"
Message-ID: <20080107213717.GB16309@parisc-linux.org>
References: <20080106144706.GA25419@elte.hu> <1199632845.5205.31.camel@localhost.localdomain> <20080106171158.GM20473@parisc-linux.org> <1199640983.5205.65.camel@localhost.localdomain> <20080106183402.GA7906@1wt.eu> <20080106185625.GM2082@does.not.exist> <20080106191044.GA1105@1wt.eu> <20080106195802.GN2082@does.not.exist> <20080106210813.GA10136@1wt.eu> <19438.1199739038@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19438.1199739038@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Personally, I've lost count of the number of times I've *not* reported a
> bug/oops just because of the "NVidia users this means you" statement, only
> to have the exact same issue reported several weeks/months later by somebody
> who's able to replicate it with an untainted kernel.

If you can reproduce a bug reliably, you can reproduce it without the
nvidia module loaded.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
