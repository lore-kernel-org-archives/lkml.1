Return-Path: <linux-kernel-owner+w=401wt.eu-S1752358AbYDMElw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752358AbYDMElw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 00:41:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750741AbYDMEll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 00:41:41 -0400
Received: from mail.deathmatch.net ([70.167.247.36]:42629 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750700AbYDMElk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 00:41:40 -0400
Date: Sun, 13 Apr 2008 00:41:26 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/7] OMFS filesystem version 3
Message-ID: <20080413044126.GA27671@hash.localnet>
References: <1208041121-26787-1-git-send-email-me@bobcopeland.com> <20080412170304.54f139e2.akpm@linux-foundation.org> <20080413033344.GA27494@hash.localnet> <20080412205544.5e12a7d4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080412205544.5e12a7d4.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 12, 2008 at 08:55:44PM -0700, Andrew Morton wrote:
> Yes, pursuing the FUSE implementation sounds a better approach - it avoids
> burdening the kernel with a filesysstem which few will be interested in and
> is more practical for use by those who _are_ interested in it.

Roger that, thanks.

-- 
Bob Copeland %% www.bobcopeland.com 

