Return-Path: <linux-kernel-owner+w=401wt.eu-S935947AbXGMHEl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935947AbXGMHEl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 03:04:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762265AbXGMHE3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 03:04:29 -0400
Received: from 74-0-229-162.T1.lbdsl.net ([74.0.229.162]:57852 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761662AbXGMHE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 03:04:27 -0400
Subject: Re: [EXT4 set 3][PATCH 1/1] ext4 nanosecond timestamp
From: Kalpak Shah <kalpak@clusterfs.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, cmm@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org, Andreas Dilger <adilger@clusterfs.com>
In-Reply-To: <4696FFBE.3030806@linux.vnet.ibm.com>
References: <1183275416.4010.125.camel@localhost.localdomain>
	 <20070710163027.1bf7e94e.akpm@linux-foundation.org>
	 <1184245126.4299.20.camel@garfield>  <4696FFBE.3030806@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Fri, 13 Jul 2007 12:35:18 +0530
Message-Id: <1184310318.4372.5.camel@garfield>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
X-SystemSpamProbe: GOOD 0.0001819 657371c75079a589827f90a9bfc709b0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-07-13 at 09:59 +0530, Aneesh Kumar K.V wrote:
> 
> Kalpak Shah wrote:
> > On Tue, 2007-07-10 at 16:30 -0700, Andrew Morton wrote:
> >> On Sun, 01 Jul 2007 03:36:56 -0400
> >> Mingming Cao <cmm@us.ibm.com> wrote:
> >>
> >>> This patch is a spinoff of the old nanosecond patches.
> >> I don't know what the "old nanosecond patches" are.  A link to a suitable
> >> changlog for those patches would do in a pinch.  Preferable would be to
> >> write a proper changelog for this patch.
> > 
> > The incremental patch contains a proper changelog describing the patch.
> > 
> 
> 
> Instead of  putting incremental patches it would be nice if we can have replacement patches.
> for the already existing patches with the comments addressed. For example if we have a 
> review comment on the patch message ( commit log ) then adding an incremental patch doesn't help.

I think that it would be easier to review just the changes that have
been made to the patches instead of having people go through the entire
patch again. I was hoping that someone with write access to ext4-git
would update the commit logs.

If replacement patches are preferred, then I will send them again.

Thanks,
Kalpak.

> 
> 
> -aneesh
> -
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

