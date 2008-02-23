Return-Path: <linux-kernel-owner+w=401wt.eu-S934868AbYBWIPg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934868AbYBWIPg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 03:15:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933148AbYBWII5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 03:08:57 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:49347 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933038AbYBWIIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 03:08:53 -0500
Date: Sat, 23 Feb 2008 00:06:01 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       netdev@vger.kernel.org, trond.myklebust@fys.uio.no
Subject: Re: [PATCH 09/28] mm: __GFP_MEMALLOC
Message-Id: <20080223000601.d35912d4.akpm@linux-foundation.org>
In-Reply-To: <20080220150306.424308000@chello.nl>
References: <20080220144610.548202000@chello.nl>
	<20080220150306.424308000@chello.nl>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Feb 2008 15:46:19 +0100 Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> __GFP_MEMALLOC will allow the allocation to disregard the watermarks, 
> much like PF_MEMALLOC.
> 

'twould be nice if the changelog had some explanation of the reason
for this change.
