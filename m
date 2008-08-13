Return-Path: <linux-kernel-owner+w=401wt.eu-S1754145AbYHMGmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145AbYHMGmT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 02:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752379AbYHMGmE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 02:42:04 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:54425 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925AbYHMGmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 02:42:02 -0400
Message-ID: <48A28165.5010202@cs.helsinki.fi>
Date: Wed, 13 Aug 2008 09:38:29 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.16 (Macintosh/20080707)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: akpm@linux-foundation.org, Christoph Lameter <clameter@sgi.com>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, andi@firstfloor.org,
       Rik van Riel <riel@redhat.com>, mpm@selenic.com
Subject: Re: [patch 15/19] Filesystem: XFS slab defragmentation
References: <20080811150616.207532384@quilx.com> <20080811150659.051842926@quilx.com> <20080812002057.GH6119@disturbed> <48A136D7.4080505@cs.helsinki.fi> <48A1D4A0.2030109@linux-foundation.org>
In-Reply-To: <48A1D4A0.2030109@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> Pekka Enberg wrote:
>>> Please update this patch as per my last comment.
>> Christoph, I'm dropping this patch from my tree.
> 
> Just apply this patch:
> 
> Subject: defrag/xfs: Move defrag setup directly after xfs_vnode_zone kmem
> cache creation

Applied, thanks!
