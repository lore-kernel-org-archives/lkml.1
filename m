Return-Path: <linux-kernel-owner+w=401wt.eu-S1758803AbZEKTbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758803AbZEKTbj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 15:31:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752453AbZEKTb1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 15:31:27 -0400
Received: from thunk.org ([69.25.196.29]:34458 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752619AbZEKTb0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 15:31:26 -0400
Date: Mon, 11 May 2009 15:30:36 -0400
From: Theodore Tso <tytso@mit.edu>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Josef Bacik <josef@redhat.com>, linux-fsdevel@vger.kernel.org,
       sandeen@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC] fiemap tester
Message-ID: <20090511193036.GE21518@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Randy Dunlap <randy.dunlap@oracle.com>,
	Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Josef Bacik <josef@redhat.com>, linux-fsdevel@vger.kernel.org,
	sandeen@redhat.com, linux-kernel@vger.kernel.org
References: <20090508191649.GG9068@unused.rdu.redhat.com> <20090508161318.c73d766c.akpm@linux-foundation.org> <20090511094639.GA7488@infradead.org> <20090511171046.GA21518@mit.edu> <4A08666A.6020700@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A08666A.6020700@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 11, 2009 at 10:54:50AM -0700, Randy Dunlap wrote:
> 
> Given that we are not lawyers:
> 
> The current kernel tree contains >3500 files that contain the phrase
> "All Rights Reserved".  Are they a problem?

Yes, but how many of them are followed with a GPL licensing statement?
And presumably we have a signed-off-by chain that which includes
someone asserting that they have followed the Developer's
Certification of Origin rules.  (That being said, it's usually better
if the All Rights Reserved is removed, after getting explicit
permission from the original copyright owner to make it available
under a GPLv2 license.)

The issue with the xfstests tree is the *only* copyright permission
statement is "All Rights Reserved", and while there is an oral
assertion from SGI that it was supposed to be released under an open
source license, there is nothing in writing or in the source
distribution indicating this, and it wasn't clear to me whether this
oral assurance happened before or after SGI was purchased by
Rackspace.

						- Ted
