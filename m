Return-Path: <linux-kernel-owner+w=401wt.eu-S1753504AbXDDG1w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504AbXDDG1w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 02:27:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992695AbXDDG1w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 02:27:52 -0400
Received: from smtp.osdl.org ([65.172.181.24]:59379 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753493AbXDDG1v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 02:27:51 -0400
Date: Tue, 3 Apr 2007 23:26:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Eric Dumazet <dada1@cosmosbay.com>, Ulrich Drepper <drepper@redhat.com>,
       Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: [patches] threaded vma patches (was Re: missing madvise
 functionality)
Message-Id: <20070403232624.11935e80.akpm@linux-foundation.org>
In-Reply-To: <46134124.2040705@yahoo.com.au>
References: <46128051.9000609@redhat.com>
	<p73648dz5oa.fsf@bingen.suse.de>
	<46128CC2.9090809@redhat.com>
	<20070403172841.GB23689@one.firstfloor.org>
	<20070403125903.3e8577f4.akpm@linux-foundation.org>
	<4612B645.7030902@redhat.com>
	<20070403202937.GE355@devserv.devel.redhat.com>
	<20070403144948.fe8eede6.akpm@linux-foundation.org>
	<4612DCC6.7000504@cosmosbay.com>
	<46130BC8.9050905@yahoo.com.au>
	<46133A8B.50203@cosmosbay.com>
	<46134124.2040705@yahoo.com.au>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 04 Apr 2007 16:09:40 +1000 Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> Andrew, do you have any objections to putting Eric's fairly
> important patch at least into -mm?

you know what to do ;)
