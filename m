Return-Path: <linux-kernel-owner+w=401wt.eu-S1758352AbZEET3u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758352AbZEET3u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 15:29:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753030AbZEET3i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 15:29:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41180 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751438AbZEET3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 15:29:37 -0400
Date: Tue, 5 May 2009 12:24:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: magnus.damm@gmail.com, linux-media@vger.kernel.org, hverkuil@xs4all.nl,
       lethal@linux-sh.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/3] mm: introduce follow_pte()
Message-Id: <20090505122442.6271c7da.akpm@linux-foundation.org>
In-Reply-To: <1241430874-12667-1-git-send-email-hannes@cmpxchg.org>
References: <20090501181449.GA8912@cmpxchg.org>
	<1241430874-12667-1-git-send-email-hannes@cmpxchg.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  4 May 2009 11:54:32 +0200
Johannes Weiner <hannes@cmpxchg.org> wrote:

> A generic readonly page table lookup helper to map an address space
> and an address from it to a pte.

umm, OK.

Is there actually some point to these three patches?  If so, what is it?
