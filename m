Return-Path: <linux-kernel-owner+w=401wt.eu-S1760860AbXGCSMN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760860AbXGCSMN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 14:12:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755408AbXGCSMA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 14:12:00 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:28161 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754683AbXGCSMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 14:12:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=A/Bv9eY9C66aImaRtvlJjx/GbgqR+Bc5Ma0O5nj/ZTasLbjlgJMy9d8I8eq6p4q74hoPR3kMjE4ZgStEXBb1By2Sbw4AkWR19EWqPTD9+8hZeoIGRwHE1XJbE7cE6Iu+nwRwnLvHuVji0Kss4FU62Wc7WpRHwj79F5pC/IVaogg=
Date: Tue, 3 Jul 2007 22:11:51 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 10/10] Scheduler profiling - Use immediate values
Message-ID: <20070703181151.GB5800@martell.zuzino.mipt.ru>
References: <20070703164046.645090494@polymtl.ca> <20070703164516.377240547@polymtl.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070703164516.377240547@polymtl.ca>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 03, 2007 at 12:40:56PM -0400, Mathieu Desnoyers wrote:
> Use immediate values with lower d-cache hit in optimized version as a
> condition for scheduler profiling call.

How much difference in performance do you see?

