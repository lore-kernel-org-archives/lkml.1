Return-Path: <linux-kernel-owner+w=401wt.eu-S1759978AbXGKDgj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759978AbXGKDgj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 23:36:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754667AbXGKDg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 23:36:29 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42105 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753110AbXGKDg1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 23:36:27 -0400
Date: Tue, 10 Jul 2007 23:35:53 -0400
From: Dave Jones <davej@redhat.com>
To: Mingming Cao <cmm@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Theodore Tso <tytso@mit.edu>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org
Subject: Re: [EXT4 set 1][PATCH 2/2] Enable extents by default for ext4dev
Message-ID: <20070711033553.GA27564@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Mingming Cao <cmm@us.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Theodore Tso <tytso@mit.edu>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
References: <1183275361.4010.119.camel@localhost.localdomain> <20070710163015.ab40ed2a.akpm@linux-foundation.org> <1184103313.3759.44.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1184103313.3759.44.camel@localhost.localdomain>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 10, 2007 at 05:35:13PM -0400, Mingming Cao wrote:
 > 
 > Sorry about this. I was using version 0.04. The latest one I can find
 > for now is 0.05(searching lkml), but it didn't catch this codling style
 > bug either. I appreciate if anyone can point me the version 0.07, thanks

It's now in-tree in scripts/checkpatch.pl
(linus' tree is still at 0.06 though, I suspect Andrew has something
 newer in -mm)

	Dave

-- 
http://www.codemonkey.org.uk
