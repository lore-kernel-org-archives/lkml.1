Return-Path: <linux-kernel-owner+w=401wt.eu-S1753888AbZALDg3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888AbZALDg3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 22:36:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752211AbZALDgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 22:36:19 -0500
Received: from thunk.org ([69.25.196.29]:41276 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752069AbZALDgS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 22:36:18 -0500
Date: Sun, 11 Jan 2009 22:36:15 -0500
From: Theodore Tso <tytso@mit.edu>
To: Simon Holm =?iso-8859-1?Q?Th=F8gersen?= <odie@cs.aau.dk>
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] jbd2: fix wrong use of do_div
Message-ID: <20090112033615.GA5798@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Simon Holm =?iso-8859-1?Q?Th=F8gersen?= <odie@cs.aau.dk>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Randy Dunlap <randy.dunlap@oracle.com>
References: <1231701393.17759.30.camel@odie.local> <1231724680.3094.3.camel@odie.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231724680.3094.3.camel@odie.local>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the patch; I've queued it for testing and will push it to
Linus.

						- Ted
