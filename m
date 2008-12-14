Return-Path: <linux-kernel-owner+w=401wt.eu-S1754993AbYLNXLZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754993AbYLNXLZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 18:11:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751753AbYLNXLQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 18:11:16 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:35468 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751687AbYLNXLP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 18:11:15 -0500
Subject: Re: [Bug #12155] Regression in 2.6.28-rc and 2.6.27-stable -
	hibernate related
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Fabio Comolli <fabio.comolli@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Greg Kroah-Hartman <gregkh@suse.de>, Chuck Ebbert <cebbert@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <200812131956.03495.rjw@sisk.pl>
References: <u7kfEgp36eE.A.qpG.Y4_QJB@chimera>
	 <T1gm2CtAHBF.A.bnH.14_QJB@chimera>
	 <b637ec0b0812131045n34bf420w3729abf24533b51c@mail.gmail.com>
	 <200812131956.03495.rjw@sisk.pl>
Content-Type: text/plain
Date: Sun, 14 Dec 2008 17:11:07 -0600
Message-Id: <1229296267.22016.2.camel@norville.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-12-13 at 19:56 +0100, Rafael J. Wysocki wrote:

> Thanks for the update, I have put this information into the Bugzilla entry.
> 
> Would everyone involved agree with reverting the above commit for now and
> revisiting the issue in the 2.6.29 time frame?

I agree.  I can't explain what's wrong, but it seems obvious that my
patch either causes or uncovers a more serious problem than it fixed.

Shaggy
-- 
David Kleikamp
IBM Linux Technology Center

