Return-Path: <linux-kernel-owner+w=401wt.eu-S1759105AbYARJLx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759105AbYARJLx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 04:11:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758898AbYARJLf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 04:11:35 -0500
Received: from koto.vergenet.net ([210.128.90.7]:48815 "EHLO koto.vergenet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756266AbYARJLc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 04:11:32 -0500
Date: Fri, 18 Jan 2008 18:11:31 +0900
From: Simon Horman <horms@verge.net.au>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Vivek Goyal <vgoyal@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ian Campbell <Ian.Campbell@citrix.com>,
       Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
       kexec@lists.infradead.org
Subject: Re: [PATCH -mm 2/2 -v2] kexec/i386: kexec page table code clean up
	- page table setup in C
Message-ID: <20080118091129.GE10957@verge.net.au>
References: <1200377149.3505.51.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1200377149.3505.51.camel@caritas-dev.intel.com>
User-Agent: Mutt/1.5.17 (2007-12-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2008 at 02:05:49PM +0800, Huang, Ying wrote:
> This patch transforms the kexec page tables setup code from assembler
> code to C code in machine_kexec_prepare. This improves readability and
> reduces code line number.

This looks good to me.

Simon Horman <horms@verge.net.au>

> Signed-off-by: Huang Ying <ying.huang@intel.com>

-- 
Horms

