Return-Path: <linux-kernel-owner+w=401wt.eu-S1753654AbYAOOA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654AbYAOOA2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 09:00:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751069AbYAOOAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 09:00:14 -0500
Received: from mx1.redhat.com ([66.187.233.31]:53543 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751029AbYAOOAM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 09:00:12 -0500
Date: Tue, 15 Jan 2008 08:56:30 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Simon Horman <horms@verge.net.au>,
       Ian Campbell <Ian.Campbell@citrix.com>,
       Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
       kexec@lists.infradead.org
Subject: Re: [PATCH -mm 0/2 -v2] kexec/i386: kexec page table code clean up
Message-ID: <20080115135630.GA23722@redhat.com>
References: <1200377142.3505.49.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1200377142.3505.49.camel@caritas-dev.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2008 at 02:05:42PM +0800, Huang, Ying wrote:
> This patchset cleans up page table setup code of kexec on i386.
> 
> This patchset is based on 2.6.24-rc5-mm1 and has been tested on i386
> with/without PAE enabled.
> 
> 
> v2:
> 
> - Rename some function names, such as alloc_page_tables ->
>   machine_kexec_alloc_page_tables, etc.
> 
> - Cleanup error processing for machine_alloc_page_tables.
> 
> 

Looks good to me.

Thanks
Vivek
