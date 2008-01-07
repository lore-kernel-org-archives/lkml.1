Return-Path: <linux-kernel-owner+w=401wt.eu-S1757471AbYAGP0m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757471AbYAGP0m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 10:26:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753605AbYAGP0f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 10:26:35 -0500
Received: from Mycroft.westnet.com ([216.187.52.7]:59876 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691AbYAGP0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 10:26:34 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18306.17536.212405.674762@stoffel.org>
Date: Mon, 7 Jan 2008 10:25:52 -0500
From: "John Stoffel" <john@stoffel.org>
To: Willy Tarreau <w@1wt.eu>
Cc: Adrian Bunk <bunk@kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Matthew Wilcox <matthew@wil.cx>, Ingo Molnar <mingo@elte.hu>,
       Peter Osterlund <petero2@telia.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [patch] scsi: revert "[SCSI] Get rid of scsi_cmnd->done"
In-Reply-To: <20080106191044.GA1105@1wt.eu>
References: <1199316785.3258.85.camel@localhost.localdomain>
	<alpine.LFD.1.00.0801021756310.3010@woody.linux-foundation.org>
	<m3ir27oe7f.fsf@telia.com>
	<1199627875.5205.1.camel@localhost.localdomain>
	<20080106144706.GA25419@elte.hu>
	<1199632845.5205.31.camel@localhost.localdomain>
	<20080106171158.GM20473@parisc-linux.org>
	<1199640983.5205.65.camel@localhost.localdomain>
	<20080106183402.GA7906@1wt.eu>
	<20080106185625.GM2082@does.not.exist>
	<20080106191044.GA1105@1wt.eu>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I'll agree with what Willy wrote here, Bugzilla is a pain to use, you
can't just dump an email into it and have it captured.  I think we
should be looking at something more like 'WebRT' which is an *issue*
tracker software.  But that too might be too heavy weight and too
noisy as well.

And suddenly it would starting putting ticket numbers onto all the
non-problem conversations we have here on lkml as well, which I'm not
sure we really want.

Does it mean that we needs to have a 'bugs@kernel.org' email for
people to report bugs/problems/issues, while lkml remains (but is
copied for all 'bugs@kernel.org' emails) primarily the developer point
of contact?  

The question to me really revolves around how do you automate the
process in a transparent manner so that people don't have to change
much how they interact with lkml.  

John
