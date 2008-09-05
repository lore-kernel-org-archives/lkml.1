Return-Path: <linux-kernel-owner+w=401wt.eu-S1754983AbYIERDl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754983AbYIERDl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 13:03:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752135AbYIERDb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 13:03:31 -0400
Received: from sabe.cs.wisc.edu ([128.105.6.20]:34448 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751996AbYIERDb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 13:03:31 -0400
Message-ID: <48C1665A.8070406@cs.wisc.edu>
Date: Fri, 05 Sep 2008 12:03:22 -0500
From: Mike Christie <michaelc@cs.wisc.edu>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Chris Leech <christopher.leech@intel.com>
CC: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       devel@open-fcoe.org
Subject: Re: [Open-FCoE] [PATCH 2/3] 24-bit types: convert iSCSI to use the
 __be24 type and	macros
References: <20080905165732.16689.50256.stgit@localhost.localdomain> <20080905165738.16689.31487.stgit@localhost.localdomain>
In-Reply-To: <20080905165738.16689.31487.stgit@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Leech wrote:
> The calling convention of hton24 is different now, it takes a single u32
> as an argument and evaluates to a __be24 lvalue.
> 
> Signed-off-by: Chris Leech <christopher.leech@intel.com>

Looks fine by me. Thanks.

Acked-by: Mike Christie <michaelc@cs.wisc.edu>
