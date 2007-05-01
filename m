Return-Path: <linux-kernel-owner+w=401wt.eu-S1753106AbXEANqD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753106AbXEANqD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 09:46:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753682AbXEANqC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 09:46:02 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41128 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753672AbXEANp5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 09:45:57 -0400
Subject: Re: [GFS2] fix bz 231369, gfs2 will oops if you specify an invalid
	mount option [2/34]
From: Steven Whitehouse <swhiteho@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org,
       Josef Whiter <jwhiter@redhat.com>
In-Reply-To: <20070501102838.GA29429@infradead.org>
References: <1178013376.5462.127.camel@quoit.chygwyn.com>
	 <1178013544.5462.131.camel@quoit.chygwyn.com>
	 <20070501102838.GA29429@infradead.org>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
	3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 ITE
Date: Tue, 01 May 2007 14:41:17 +0100
Message-Id: <1178026877.5462.204.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 2007-05-01 at 11:28 +0100, Christoph Hellwig wrote:
> Having the bugzilla ids in the subject it a bit annoying.  I understand
> that cross-referencing bugs to patches is quite useful, but could
> you use a special tag in the message body instead, similar to how
> XFS use the SGI-PV: tag.  This also means you tell people which
> bugzilla the bug actually was in.
> 
That sounds quite a useful idea. I'll see what we can do,

Steve.


