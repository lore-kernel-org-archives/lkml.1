Return-Path: <linux-kernel-owner+w=401wt.eu-S932207AbXCFLPG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932207AbXCFLPG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 06:15:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933242AbXCFLPG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 06:15:06 -0500
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:57702 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932207AbXCFLPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 06:15:04 -0500
Message-ID: <45ED4CF7.7030501@linux.vnet.ibm.com>
Date: Tue, 06 Mar 2007 16:43:59 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Thunderbird 1.5.0.5 (X11/20060728)
MIME-Version: 1.0
To: Shane <ibm-main@tpg.com.au>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org, riel@redhat.com,
       vatsa@in.ibm.com, ckrm-tech@lists.sourceforge.net, balbir@in.ibm.com,
       xemul@sw.ru, menage@google.com, devel@openvz.org, clameter@sgi.com
Subject: Re: [ckrm-tech] [PATCH 3/3][RFC] Containers: Pagecache controller
 reclaim
References: <20070305145237.003560000@linux.vnet.ibm.com> > <20070305145311.247699000@linux.vnet.ibm.com>> <1173178212.4998.54.camel@localhost.localdomain>
In-Reply-To: <1173178212.4998.54.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Shane wrote:
> Anyone else have trouble fitting this patch ???.
> I see a later version today, but not markedly different from this
> mornings (Aus time). Initially I thought I had the first version, prior
> to Balbir's RSS controller V2 re-write, but apparently not.
> Kernel 2.6.20.1

Hi Shane,

I did post the same patch again today since the previous post
yesterday did not showup on LKML.  I have not changed the version
since it is the same patch.

Next time around i will explicitly mention that this is the same patch
posted again.

> Had to toss it away so I could do some base line testing - I'll redo the
> build and see where the mis-matches are.

Please let me know if so see any problem running the patch.  The
patches are against 2.6.20 only since dependent patches are at that level.

--Vaidy

