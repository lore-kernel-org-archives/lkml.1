Return-Path: <linux-kernel-owner+w=401wt.eu-S1754029AbZFASMe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029AbZFASMe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 14:12:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752545AbZFASMS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 14:12:18 -0400
Received: from one.firstfloor.org ([213.235.205.2]:58319 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491AbZFASMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 14:12:17 -0400
Date: Mon, 1 Jun 2009 20:19:17 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Andi Kleen <andi@firstfloor.org>, Russ Anderson <rja@sgi.com>,
       hugh@veritas.com, riel@redhat.com, akpm@linux-foundation.org,
       chris.mason@oracle.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, fengguang.wu@intel.com
Subject: Re: [PATCH] [13/16] HWPOISON: The high level memory error handler in the VM v3
Message-ID: <20090601181917.GR1065@one.firstfloor.org>
References: <200905271012.668777061@firstfloor.org> <20090527201239.C2C9C1D0294@basil.firstfloor.org> <20090528082616.GG6920@wotan.suse.de> <20090528093141.GD1065@one.firstfloor.org> <20090528120854.GJ6920@wotan.suse.de> <20090528134520.GH1065@one.firstfloor.org> <20090528165625.GA17572@sgi.com> <20090530064244.GJ1065@one.firstfloor.org> <20090601113933.GD5018@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090601113933.GD5018@wotan.suse.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Surely you can test it out these cases with debugging code or printks
> and then take them out of production code?

I made it a debugging printk now.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
