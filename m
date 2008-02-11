Return-Path: <linux-kernel-owner+w=401wt.eu-S1755069AbYBKFyB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755069AbYBKFyB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 00:54:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751249AbYBKFxx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 00:53:53 -0500
Received: from relay2.sgi.com ([192.48.171.30]:51431 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751224AbYBKFxx (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 00:53:53 -0500
Date: Mon, 11 Feb 2008 16:53:40 +1100
From: David Chinner <dgc@sgi.com>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: xfs-masters@oss.sgi.com, LKML <linux-kernel@vger.kernel.org>,
       Tim Shimmin <tes@sgi.com>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] xfs: convert beX_add to beX_add_cpu (new common API)
Message-ID: <20080211055340.GT155407@sgi.com>
References: <20080210101759.GC6737@joi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080210101759.GC6737@joi>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 10, 2008 at 11:18:09AM +0100, Marcin Slusarz wrote:
> This patch was in Andrew tree, but it was uncomplete.
> Here is updated version.
>
> ---
> remove beX_add functions and replace all uses with beX_add_cpu
> 
> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> ---

Looks good. You can add a:

Reviewed-by: Dave Chinner <dgc@sgi.com>

To the patch.

Andrew - feel free to push this to Linus with the other 2 
patches in this series when you are ready.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
