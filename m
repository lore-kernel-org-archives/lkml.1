Return-Path: <linux-kernel-owner+w=401wt.eu-S1756731AbYKDTUh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756731AbYKDTUh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 14:20:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753185AbYKDTU1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 14:20:27 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60727 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751651AbYKDTUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 14:20:25 -0500
Date: Tue, 4 Nov 2008 11:19:23 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James.Bottomley@HansenPartnership.com, michaelc@cs.wisc.edu,
       fujita.tomonori@lab.ntt.co.jp, jeff@garzik.org, osd-dev@open-osd.org,
       linux-scsi@vger.kernel.org, Sami.Iren@seagate.com, pw@padd.com,
       linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Subject: Re: [PATCHSET 00/18] open-osd: OSD Initiator library for Linux
Message-Id: <20081104111923.bb19c238.akpm@linux-foundation.org>
In-Reply-To: <491073BB.4000900@panasas.com>
References: <48876009.8010701@panasas.com>
	<491073BB.4000900@panasas.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 04 Nov 2008 18:09:31 +0200
Boaz Harrosh <bharrosh@panasas.com> wrote:

> 
> Please consider for inclusion, an in-kernel OSD initiator
> library. Its main users are planned to be various OSD based file
> systems and the pNFS-Objects Layout Driver. (To be submitted soon)
>  
> To try out and run the library please visit
> http://open-osd.org and follow the instructions there.
> 
> The submitted patchset is also available via git at:
>    git://git.open-osd.org/linux-open-osd.git osd
>    http://git.open-osd.org/gitweb.cgi?p=linux-open-osd.git;a=shortlog;h=osd
> 
> Or a compact out-of-tree repository that includes sources 
> and some extras:
>    git://git.open-osd.org/open-osd.git master
>    http://git.open-osd.org/gitweb.cgi?p=open-osd.git;a=summary
> 
> ...
>
> We would like this to sit in -mm tree for a while to make sure it is compilable
> on all platform.

The best way to do that is to include your git tree in linux-next.  If
this code has a probably-will-be-merged-in-2.6.29 status then please
prepare a branch for Stephen to include in the linux-next lineup.

