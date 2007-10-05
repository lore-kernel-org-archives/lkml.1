Return-Path: <linux-kernel-owner+w=401wt.eu-S1756839AbXJEK1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756839AbXJEK1W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 06:27:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751462AbXJEK1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 06:27:14 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:37814 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997AbXJEK1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 06:27:13 -0400
Date: Fri, 5 Oct 2007 11:26:34 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: gurudas pai <gurudas.pai@oracle.com>
cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [BUG] kernel BUG at arch/i386/mm/highmem.c:15!  on 2.6.23-rc8/rc9
In-Reply-To: <4705B568.6020502@oracle.com>
Message-ID: <Pine.LNX.4.64.0710051124280.24560@blonde.wat.veritas.com>
References: <47048A0C.4020608@oracle.com> <200710040053.19570.nickpiggin@yahoo.com.au>
 <200710040139.04201.nickpiggin@yahoo.com.au> <4704BA1F.4070408@oracle.com>
 <Pine.LNX.4.64.0710041647090.17987@blonde.wat.veritas.com> <4705A63A.1090103@oracle.com>
 <4705B568.6020502@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Oct 2007, gurudas pai wrote:
> gurudas pai wrote:
> > Hugh Dickins wrote:
> > >
> > > [PATCH] fix sys_remap_file_pages BUG at highmem.c:15!
> > 
> > Yes, indeed this patch worked for me , test completed successfully!! (on
> > preempt kernel). Will continue testing with non-preempt kernel and update
> > you if I hit any issue.
> 
> Completed testing on non-preempt successfully without any issue.

Great: many thanks for your report and testing and feedback.

Hugh
