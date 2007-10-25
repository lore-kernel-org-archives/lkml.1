Return-Path: <linux-kernel-owner+w=401wt.eu-S1759744AbXJYShE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759744AbXJYShE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 14:37:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753867AbXJYSgw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 14:36:52 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:60339 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753337AbXJYSgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 14:36:49 -0400
Date: Thu, 25 Oct 2007 20:36:48 +0200
From: Jan Kara <jack@suse.cz>
To: Nick Piggin <npiggin@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] fs: restore nobh
Message-ID: <20071025183648.GA12883@atrey.karlin.mff.cuni.cz>
References: <20071008065227.GB14949@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071008065227.GB14949@wotan.suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

> This is overdue, sorry. Got a little complicated, and I've been away from
> my filesystem test setup so I didn't want ot send it (lucky, coz I found
> a bug after more substantial testing).
> 
> Anyway, RFC?
  A bit overdue review but since I haven't seen anybody else replying...
I've read the patch and it looks fine. So feel free to add
Acked-by (or even Reviewed-by if we use it...): Jan Kara <jack@suse.cz>

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
