Return-Path: <linux-kernel-owner+w=401wt.eu-S933233AbXF2O3i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933233AbXF2O3i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 10:29:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760368AbXF2O32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 10:29:28 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:57772 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759739AbXF2O31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 10:29:27 -0400
Message-ID: <46851741.3030707@garzik.org>
Date: Fri, 29 Jun 2007 10:29:21 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>,
       "Amit K. Arora" <aarora@linux.vnet.ibm.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org, David Chinner <dgc@sgi.com>,
       Andreas Dilger <adilger@clusterfs.com>, suparna@in.ibm.com,
       cmm@us.ibm.com, xfs@oss.sgi.com
Subject: Re: [PATCH 0/6][TAKE5] fallocate system call
References: <20070512080157.GF85884050@sgi.com> <20070612061652.GA6320@amitarora.in.ibm.com> <20070613235217.GS86004887@sgi.com> <20070614091458.GH5181@schatzie.adilger.int> <20070614120413.GD86004887@sgi.com> <20070614193347.GN5181@schatzie.adilger.int> <20070625132810.GA1951@amitarora.in.ibm.com> <20070628025543.9467216f.akpm@linux-foundation.org> <20070628175757.GA1674@amitarora.in.ibm.com> <20070628113342.c9c0f49c.akpm@linux-foundation.org> <20070629135612.GH29279@thunk.org>
In-Reply-To: <20070629135612.GH29279@thunk.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> I don't think we have a problem here.  What we have now is fine, and

It's fine for ext4, but not the wider world.  This is a common problem 
created by parallel development when code dependencies exist.


> In any case, the plan is to push all of the core bits into Linus tree
> for 2.6.22 once it opens up, which should be Real Soon Now, it looks
> like.

Presumably you mean 2.6.23.

	Jeff



