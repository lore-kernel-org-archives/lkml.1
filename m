Return-Path: <linux-kernel-owner+w=401wt.eu-S1752803AbZAFJ0n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803AbZAFJ0n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 04:26:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750967AbZAFJ01
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 04:26:27 -0500
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:43942 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbZAFJ00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 04:26:26 -0500
Date: Tue, 6 Jan 2009 10:32:01 +0200
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/8] calgary: add map_page and unmap_page
Message-ID: <20090106083201.GD6841@il.ibm.com>
References: <1231166848-20149-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1231166848-20149-2-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1231166848-20149-3-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1231166848-20149-4-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1231166848-20149-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231166848-20149-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 05, 2009 at 11:47:24PM +0900, FUJITA Tomonori wrote:
> This is a preparation of struct dma_mapping_ops unification. We use
> map_page and unmap_page instead of map_single and unmap_single.
> 
> We will remove map_single and unmap_single hooks in the last patch in
> this patchset.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Cc: Muli Ben-Yehuda <muli@il.ibm.com>

Calgary bits look fine.

Acked-by: Muli Ben-Yehuda <muli@il.ibm.com>

Cheers,
Muli
-- 
SYSTOR 2009---The Israeli Experimental Systems Conference
May 4-6, 2009, Haifa, Israel
http://www.haifa.il.ibm.com/conferences/systor2009/
