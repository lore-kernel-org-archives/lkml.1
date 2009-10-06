Return-Path: <linux-kernel-owner+w=401wt.eu-S932989AbZJFSPP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932989AbZJFSPP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 14:15:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932407AbZJFSPP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 14:15:15 -0400
Received: from thunk.org ([69.25.196.29]:40840 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932290AbZJFSPO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 14:15:14 -0400
Date: Tue, 6 Oct 2009 14:14:09 -0400
From: Theodore Tso <tytso@mit.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Dirk Hohndel <hohndel@infradead.org>,
       Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.32-rc3
Message-ID: <20091006181409.GE24677@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>, Dirk Hohndel <hohndel@infradead.org>,
	Len Brown <lenb@kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain> <alpine.LFD.2.00.0910052140100.309@localhost.localdomain> <1254797502.14122.146.camel@dhohndel-mobl.amr.corp.intel.com> <alpine.LFD.2.01.0910060705240.3432@localhost.localdomain> <20091006144449.GA23078@elte.hu> <alpine.LFD.2.01.0910060815320.3432@localhost.localdomain> <alpine.LFD.2.01.0910060828530.3432@localhost.localdomain> <20091006174450.GC24677@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091006174450.GC24677@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BTW, just out of yucks, after experimenting a bit with git log
--pretty=format:%P and git-describe, here are the top parents used to
base patch commits that were merged during the recent merge window:

      5 v2.6.30
      5 v2.6.31-git3
      6 v2.6.31-git8
      6 v2.6.31-git10
      6 v2.6.31-git15
      7 v2.6.31-git6
      7 v2.6.31-git11
      8 v2.6.31-git4
      9 v2.6.31-git5
      9 v2.6.31-git14
     11 v2.6.31-git2
     11 v2.6.31-git9
     11 v2.6.31-git12
     18 v2.6.31

					- Ted
