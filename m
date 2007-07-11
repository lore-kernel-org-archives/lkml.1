Return-Path: <linux-kernel-owner+w=401wt.eu-S1758224AbXGKGPe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758224AbXGKGPe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 02:15:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753374AbXGKGPZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 02:15:25 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:39900 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753145AbXGKGPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 02:15:23 -0400
Subject: Re: [EXT4 set 1][PATCH 2/2] Enable extents by default for ext4dev
From: Mingming Cao <cmm@us.ibm.com>
Reply-To: cmm@us.ibm.com
To: Dave Jones <davej@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Theodore Tso <tytso@mit.edu>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org
In-Reply-To: <20070711033553.GA27564@redhat.com>
References: <1183275361.4010.119.camel@localhost.localdomain>
	 <20070710163015.ab40ed2a.akpm@linux-foundation.org>
	 <1184103313.3759.44.camel@localhost.localdomain>
	 <20070711033553.GA27564@redhat.com>
Content-Type: text/plain
Organization: IBM Linux Technology Center
Date: Tue, 10 Jul 2007 23:15:24 -0400
Message-Id: <1184123724.20193.58.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-33.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-10 at 23:35 -0400, Dave Jones wrote:
> On Tue, Jul 10, 2007 at 05:35:13PM -0400, Mingming Cao wrote:
>  > 
>  > Sorry about this. I was using version 0.04. The latest one I can find
>  > for now is 0.05(searching lkml), but it didn't catch this codling style
>  > bug either. I appreciate if anyone can point me the version 0.07, thanks
> 
> It's now in-tree in scripts/checkpatch.pl
> (linus' tree is still at 0.06 though, I suspect Andrew has something
>  newer in -mm)
> 

Thanks, Andy has uploaded the 0.07 version at
http://www.shadowen.org/~apw/public/checkpatch/checkpatch.pl-0.07


Mingming

