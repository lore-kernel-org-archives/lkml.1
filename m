Return-Path: <linux-kernel-owner+w=401wt.eu-S1031641AbXEAJww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031641AbXEAJww (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 05:52:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031640AbXEAJww
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 05:52:52 -0400
Received: from ns2.suse.de ([195.135.220.15]:38737 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031641AbXEAJwv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 05:52:51 -0400
From: Neil Brown <neilb@suse.de>
To: Christoph Hellwig <hch@infradead.org>
Date: Tue, 1 May 2007 19:52:11 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17975.3531.838077.563475@notabene.brown>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: nfsd/md patches Re: 2.6.22 -mm merge plans
In-Reply-To: message from Christoph Hellwig on Tuesday May 1
References: <20070430162007.ad46e153.akpm@linux-foundation.org>
	<17974.34116.479061.912980@notabene.brown>
	<20070501090843.GB17949@infradead.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday May 1, hch@infradead.org wrote:
> apropos nfsd patches, what's the merge plans for my two export ops
> patch series?

Still sitting in my tree - I've had my mind on other things
(nfs-utils, portmap....) and let them slip - sorry.

I think also there was an unanswered question about the second series
(there first I am completely happy with).

> Date: Fri, 30 Mar 2007 13:34:53 +1000
> 
> My only question involves motivation.
> 
>   You say "less complex", but to me it just looks "different" - though
>   being very familiar with the original, that might be a biased view.
>   Can you say more about how it is less complex?
>   Maybe the extension to generic 64bit support will make that clear...
> 
>   But then generic 64bit support should just be an independent set of
>   helper functions that can be plugged in to the export_operations
>   structure.
> 

It think I programmed myself to use a reply to that to be my wake_up
to forwarded them on, and forgot to register a timeout handler....

NeilBrown
