Return-Path: <linux-kernel-owner+w=401wt.eu-S934224AbZKYImi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934224AbZKYImi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 03:42:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754763AbZKYImg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 03:42:36 -0500
Received: from daytona.panasas.com ([67.152.220.89]:1372 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752435AbZKYImf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 03:42:35 -0500
Message-ID: <4B0CEDFD.2050107@panasas.com>
Date: Wed, 25 Nov 2009 10:42:37 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090924 Remi/fc10 Thunderbird/3.0b4
MIME-Version: 1.0
To: "J. Bruce Fields" <bfields@citi.umich.edu>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-parisc <linux-parisc@vger.kernel.org>,
       sparclinux <sparclinux@vger.kernel.org>,
       linux-s390 <linux-s390@vger.kernel.org>,
       NFS list <linux-nfs@vger.kernel.org>,
       pNFS Mailing List <pnfs@linux-nfs.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCHSET 0-5] remove unneeded nfsd #includes
References: <4B0C1EB7.50508@panasas.com> <20091124230852.GA468@fieldses.org>
In-Reply-To: <20091124230852.GA468@fieldses.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Nov 2009 08:42:41.0106 (UTC) FILETIME=[3FD24320:01CA6DAB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2009 01:08 AM, J. Bruce Fields wrote:
> On Tue, Nov 24, 2009 at 07:58:15PM +0200, Boaz Harrosh wrote:
>> Why is debug.h exported from Kernel? (include/linux/nfsd/Kbuild)
> 
> I suppose it's so rpcdebug can get the rpc debug flags; see e.g.
> nfs-utils/tools/rpcdebug/rpcdebug.c.
> 

OK, thanks, so I didn't touch it

> --b.
