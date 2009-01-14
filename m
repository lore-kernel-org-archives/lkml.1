Return-Path: <linux-kernel-owner+w=401wt.eu-S1762817AbZANOux@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762817AbZANOux (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 09:50:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754173AbZANOun
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 09:50:43 -0500
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:40064 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754241AbZANOum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 09:50:42 -0500
Subject: Re: [PATCH 00/14] Kernel memory leak detector
From: Catalin Marinas <catalin.marinas@arm.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20090115010141.42e1dfc5.sfr@canb.auug.org.au>
References: <20081219181255.7778.52219.stgit@pc1117.cambridge.arm.com>
	 <20090108144538.e5195575.akpm@linux-foundation.org>
	 <1231753866.10982.11.camel@pc1117.cambridge.arm.com>
	 <20090112022138.bd2e6ce4.akpm@linux-foundation.org>
	 <20090112213339.feefdd02.sfr@canb.auug.org.au>
	 <1231936220.24082.11.camel@pc1117.cambridge.arm.com>
	 <20090115010141.42e1dfc5.sfr@canb.auug.org.au>
Content-Type: text/plain
Organization: ARM Ltd
Date: Wed, 14 Jan 2009 14:50:02 +0000
Message-Id: <1231944602.24082.42.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Jan 2009 14:50:02.0900 (UTC) FILETIME=[61A1DD40:01C97657]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-01-15 at 01:01 +1100, Stephen Rothwell wrote:
> On Wed, 14 Jan 2009 12:30:20 +0000 Catalin Marinas <catalin.marinas@arm.com> wrote:
> > Are you OK with applying patches to linux-next (git am) rather than
> > using git merge? This way I can rebase kmemleak on top of linux-next.
> 
> I would much prefer a few conflicts to carrying a post linux-next patch
> because linux-next can change radically day to day - especially since we
> know there will be clashes in the areas of files you would be patching.
> 
> So lets use the above git tree and see how we go. OK?

It sounds fine. Thanks.

-- 
Catalin

