Return-Path: <linux-kernel-owner+w=401wt.eu-S1752900AbYAOOBB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900AbYAOOBB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 09:01:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751144AbYAOOAu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 09:00:50 -0500
Received: from mx1.redhat.com ([66.187.233.31]:53578 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756634AbYAOOAt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 09:00:49 -0500
Date: Tue, 15 Jan 2008 08:57:17 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Simon Horman <horms@verge.net.au>,
       Ian Campbell <Ian.Campbell@citrix.com>,
       Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
       kexec@lists.infradead.org
Subject: Re: [PATCH -mm 2/2 -v2] kexec/i386: kexec page table code clean up
	- page table setup in C
Message-ID: <20080115135717.GC23722@redhat.com>
References: <1200377149.3505.51.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1200377149.3505.51.camel@caritas-dev.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2008 at 02:05:49PM +0800, Huang, Ying wrote:
> This patch transforms the kexec page tables setup code from assembler
> code to C code in machine_kexec_prepare. This improves readability and
> reduces code line number.
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>
> 

Looks good to me.

Thanks
Vivek
