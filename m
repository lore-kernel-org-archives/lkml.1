Return-Path: <linux-kernel-owner+w=401wt.eu-S1751218AbXBMJZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751218AbXBMJZc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 04:25:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751222AbXBMJZc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 04:25:32 -0500
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:46372 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218AbXBMJZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 04:25:30 -0500
Subject: Re: [patch 0/3] 2.6.20 fix for PageUptodate memorder problem (try
	3)
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Nick Piggin <npiggin@suse.de>
Cc: Andrew Morton <akpm@osdl.org>, Hugh Dickins <hugh@veritas.com>,
       Linux Memory Management <linux-mm@kvack.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20070213055229.GB18792@wotan.suse.de>
References: <20070210001844.21921.48605.sendpatchset@linux.site>
	 <1171147495.31563.5.camel@localhost> <20070213055229.GB18792@wotan.suse.de>
Content-Type: text/plain
Organization: IBM Corporation
Date: Tue, 13 Feb 2007 10:25:33 +0100
Message-Id: <1171358733.3138.0.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-02-13 at 06:52 +0100, Nick Piggin wrote:
> Thanks for the confirmation.
> 
> I'll obviously have to resend a new patchset because I made a silly
> paper-bag bug with this one. May I say that the s390 specific part of
> the change is acked-by: you?

Yes.

-- 
blue skies,
  Martin.

Martin Schwidefsky
Linux for zSeries Development & Services
IBM Deutschland Entwicklung GmbH

"Reality continues to ruin my life." - Calvin.


