Return-Path: <linux-kernel-owner+w=401wt.eu-S1760652AbXISPBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760652AbXISPBS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 11:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755579AbXISPBK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 11:01:10 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:57197 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755471AbXISPBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 11:01:08 -0400
Date: Wed, 19 Sep 2007 20:33:53 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Borislav Petkov <bbpetkov@yahoo.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Muli Ben-Yehuda <muli@il.ibm.com>, amitkale@netxen.com,
       achim_leubner@adaptec.com
Subject: Re: [PATCH 1/1] unify DMA_..BIT_MASK definitions: v3.1
In-Reply-To: <20070918194647.GA23800@gollum.tnic>
Message-ID: <alpine.LFD.0.999.0709192031220.7697@enigma.security.iitk.ac.in>
References: <20070918194647.GA23800@gollum.tnic>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 18 Sep 2007, Borislav Petkov wrote:
> 
> These patches remove redundant DMA_..BIT_MASK definitions across two
> drivers. The computation of the majority of the bitmasks is done by the
> compiler. The initial split of the patch touching each a different file got
> removed due to possible git bisect breakage.
> 
> Andrew, can you please apply this patch for it touches drivers maintained by
> different people and i there might be responsibility issues, imho.
> 
> Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
> Cc: Jeremy Fitzhardinge <jeremy@goop.org>
> Cc: Muli Ben-Yehuda <muli@il.ibm.com>

Thanks, Borislav.

Reviewed-by: Satyam Sharma <satyam@infradead.org>
