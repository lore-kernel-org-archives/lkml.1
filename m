Return-Path: <linux-kernel-owner+w=401wt.eu-S1754834AbXENNW4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834AbXENNW4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 09:22:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752869AbXENNWt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 09:22:49 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:43880 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751908AbXENNWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 09:22:48 -0400
X-Sasl-enc: D0E/+q+bF0TQHjOKDyOamc+NrsF0S3pW8SUE2sF5YOmj 1179148967
Subject: Read-only bind mount patches
From: Ian Kent <raven@themaw.net>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, haveblue@us.ibm.com,
       linux-kernel@vger.kernel.org,
       Trond Myklebust <Trond.Myklebust@netapp.com>
Content-Type: text/plain
Date: Mon, 14 May 2007 21:22:40 +0800
Message-Id: <1179148960.3811.33.camel@raven.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Christoph,

I'm trying to find information about "read-only bind mount" patches
posted to LKML last year by Dave Hansen. As far as I can tell there were
a number of postings and several patches in the set were included in
2.6.19 as preparation for more of the patch set.

I've sent mail to Dave but he must be to busy, on leave or not keen on
getting these patches included any more as I've not had a response.

It looks like you had some interest in the patches so I was wondering if
you know who, if anyone, is working on them or where I could locate a
coherent, most up to date set of the remaining patches?

The reason I'm chasing this is that recent changes to the NFS client
cause all mount flags to be ignored on all but the first mount which is
causing a fair bit of unrest for some users. Trond seemed sure that the
VFS read-only bind mount updates would resolve this.

Any help, information or input would be much appreciated.

Ian


