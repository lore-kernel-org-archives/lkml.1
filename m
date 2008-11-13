Return-Path: <linux-kernel-owner+w=401wt.eu-S1754275AbYKMO3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754275AbYKMO3U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 09:29:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754127AbYKMO26
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 09:28:58 -0500
Received: from nlpi053.sbcis.sbc.com ([207.115.36.82]:43753 "EHLO
	nlpi053.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683AbYKMO25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 09:28:57 -0500
Date: Thu, 13 Nov 2008 08:28:24 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, travis@sgi.com,
       Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: [patch 0/7] cpu alloc stage 2
In-Reply-To: <20081113103510.4a6a1d3a.sfr@canb.auug.org.au>
Message-ID: <Pine.LNX.4.64.0811130827450.19293@quilx.com>
References: <20081105231634.133252042@quilx.com> <20081112175717.4a1fd679.sfr@canb.auug.org.au>
 <Pine.LNX.4.64.0811121406550.31606@quilx.com> <20081113103510.4a6a1d3a.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Nov 2008, Stephen Rothwell wrote:

> > I will push out a new patchset and tree in the next hour or so for
> > you to merge into linux-next.
>
> Why not just add these to the cpu_alloc tree I already have?

What happens if there are problems with the next stage? I want to make
sure that at least the basis is merged.

