Return-Path: <linux-kernel-owner+w=401wt.eu-S1756276AbXGPHUT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756276AbXGPHUT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 03:20:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753204AbXGPHUF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 03:20:05 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:54776 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752198AbXGPHUC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 03:20:02 -0400
Subject: Re: [EXT4 set 9][PATCH
	4/5]Morecleanups:ext4_extent_compilation_fixes
From: Mingming Cao <cmm@us.ibm.com>
Reply-To: cmm@us.ibm.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org
In-Reply-To: <20070710231837.2848ab83.akpm@linux-foundation.org>
References: <1183275531.4010.140.camel@localhost.localdomain>
	 <20070710231837.2848ab83.akpm@linux-foundation.org>
Content-Type: text/plain
Organization: IBM Linux Technology Center
Date: Mon, 16 Jul 2007 00:19:46 -0700
Message-Id: <1184570386.4005.13.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-33.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-10 at 23:18 -0700, Andrew Morton wrote:
> On Sun, 01 Jul 2007 03:38:51 -0400 Mingming Cao <cmm@us.ibm.com> wrote:
> 
> > Subject: [EXT4 set 9][PATCH 4/5]Morecleanups:ext4_extent_compilation_fixes
> > Date: 	Sun, 01 Jul 2007 03:38:51 -0400
> > Sender: linux-kernel-owner@vger.kernel.org
> > Organization: IBM Linux Technology Center
> > X-Mailer: Evolution 2.8.0 (2.8.0-33.el5) 
> > 
> > From: Dmitry Monakhov <dmonakhov@sw.ru>
> > Subject: ext4: extent compilation fixes
> 
> I hope this patch series will hit git with nice titles like "ext4: extent
> compilation fixes" and not funny ones like
> "Morecleanups:ext4_extent_compilation_fixes".
> 
Sure, the changelog keep the nice tile "Subject: ext4: extent
compilation fixes"

> > Fix compilation with EXT_DEBUG, also fix leXX_to_cpu convertions.
> 
> "conversions".

Done.

Thanks,
Mingming

