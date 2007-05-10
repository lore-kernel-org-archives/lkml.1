Return-Path: <linux-kernel-owner+w=401wt.eu-S1756550AbXEJCah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756550AbXEJCah (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 22:30:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754351AbXEJCaa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 22:30:30 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:55603 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754300AbXEJCa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 22:30:29 -0400
Date: Wed, 9 May 2007 19:30:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org, hch@infradead.org
Subject: Re: [patch 00/10] Linux Kernel Markers for 2.6.21-mm2
Message-Id: <20070509193008.b3f0a2f7.akpm@linux-foundation.org>
In-Reply-To: <20070510015555.973107048@polymtl.ca>
References: <20070510015555.973107048@polymtl.ca>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 09 May 2007 21:55:55 -0400 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> He is an updated, folded, version of the Linux Kernel Markers. It replaces the
> version found in 2.6.21-mm2 at the exact same spot in the series file.

urgh.  That basically takes us back to square one with whatever review has
happened.

I suppose I could do s/MARK/trace_mark/g on the existing diffs then have a
go at generating incremental diffs so we can review these changes.

