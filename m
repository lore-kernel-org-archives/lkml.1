Return-Path: <linux-kernel-owner+w=401wt.eu-S1762300AbYCFMiE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762300AbYCFMiE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 07:38:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933545AbYCFMhK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 07:37:10 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:57526 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933530AbYCFMhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 07:37:07 -0500
Date: Thu, 6 Mar 2008 07:37:05 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: xfs <xfs-masters@oss.sgi.com>, Christoph Hellwig <hch@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 6/9] xfs: replace __inline with inline
Message-ID: <20080306123705.GA12232@infradead.org>
References: <1204679839.5698.72.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1204679839.5698.72.camel@brick>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 04, 2008 at 05:17:19PM -0800, Harvey Harrison wrote:
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
>  fs/xfs/linux-2.6/xfs_cred.h  |    2 +-
>  fs/xfs/linux-2.6/xfs_stats.h |    4 ++--
>  fs/xfs/quota/xfs_qm_stats.h  |    4 ++--
>  3 files changed, 5 insertions(+), 5 deletions(-)

This looks good to me, especially given that plain 'inline' is the
canonical form in xfs these days.

