Return-Path: <linux-kernel-owner+w=401wt.eu-S1758774AbYF0Mij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758774AbYF0Mij (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 08:38:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753022AbYF0Mib
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 08:38:31 -0400
Received: from saeurebad.de ([85.214.36.134]:39393 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751573AbYF0Mia (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 08:38:30 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Hugh Dickins <hugh@veritas.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Andy Whitcroft <apw@shadowen.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mmotm] remove unused vma_page_offset()
References: <874p7fyvvl.fsf@skyscraper.fehenstaub.lan>
	<Pine.LNX.4.64.0806271300350.16003@blonde.site>
Date: Fri, 27 Jun 2008 14:37:57 +0200
In-Reply-To: <Pine.LNX.4.64.0806271300350.16003@blonde.site> (Hugh Dickins's
	message of "Fri, 27 Jun 2008 13:13:16 +0100 (BST)")
Message-ID: <87hcbfxdcq.fsf@skyscraper.fehenstaub.lan>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000002, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Hugh Dickins <hugh@veritas.com> writes:

> On Fri, 27 Jun 2008, Johannes Weiner wrote:
>> Function has no callees, drop it.
>> 
>> Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
>> ---
>
> Yes, I noticed that too; but I also thought vma_pagecache_offset()
> below it needs a name change, and was planning on sending Andrew
> the patch at the end, okay to replace yours with that?

Jawohl, that's fine with me.

	Hannes
