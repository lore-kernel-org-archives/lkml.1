Return-Path: <linux-kernel-owner+w=401wt.eu-S1423013AbXBBE5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423013AbXBBE5V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 23:57:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423002AbXBBE5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 23:57:21 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52326 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423007AbXBBE5U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 23:57:20 -0500
From: Neil Brown <neilb@suse.de>
To: Roland Dreier <rdreier@cisco.com>
Date: Fri, 2 Feb 2007 15:56:52 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17858.50324.772378.397661@notabene.brown>
Cc: Andrew Morton <akpm@osdl.org>, nfs@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 000 of 14] knfsd: Preparation for IPv6 support in NFS server.
In-Reply-To: message from Roland Dreier on Thursday February 1
References: <20070202153531.18622.patches@notabene>
	<adahcu55fiu.fsf@cisco.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday February 1, rdreier@cisco.com wrote:
>  > They are mostly from Chuck Level and make preparating for IPv6 support
>  > in the NFS server.
>  > They are *not* for 2.6.20, but should be ok for .21.
> 
> Out of curiousity, does this patch series reduce the delta between the
> NFS/RDMA tree and mainline Linux?  In other words does this bring
> NFS/RDMA closer to merging?
> 
>  - R.

No idea.  I haven't seen any RDMA patches.  I seem to remember hearing
them mentioned some time ago, but I haven't gone looking for them.

NeilBrown
