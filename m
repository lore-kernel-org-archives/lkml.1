Return-Path: <linux-kernel-owner+w=401wt.eu-S1753612AbZJZV4w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612AbZJZV4w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 17:56:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752790AbZJZV4v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 17:56:51 -0400
Received: from one.firstfloor.org ([213.235.205.2]:33912 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757AbZJZV4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 17:56:51 -0400
Date: Mon, 26 Oct 2009 22:56:54 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Chris Wright <chrisw@sous-sol.org>
Cc: Andi Kleen <andi@firstfloor.org>, David Woodhouse <dwmw2@infradead.org>,
       iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] allow fallback to swiotlb on hw iommu init
	failures
Message-ID: <20091026215654.GB3355@basil.fritz.box>
References: <20091023012158.177308035@sequoia.sous-sol.org> <87hbtmy6jc.fsf@basil.nowhere.org> <20091026162637.GA27699@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091026162637.GA27699@sequoia.sous-sol.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[... 4 options described ...]
> 
> This series implements the fourth option.

Ok makes sense.

This should be in the git log somewhere.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
