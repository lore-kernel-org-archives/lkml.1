Return-Path: <linux-kernel-owner+w=401wt.eu-S1764331AbYEAVe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764331AbYEAVe0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 17:34:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760234AbYEAVeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 17:34:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39479 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759485AbYEAVeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 17:34:17 -0400
Date: Thu, 1 May 2008 14:33:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Greg Ungerer <gerg@snapgear.com>
Cc: torvalds@linux-foundation.org, gerg@uclinux.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] m68knommu: ColdFire add support for kernel preemption
Message-Id: <20080501143336.552e39e1.akpm@linux-foundation.org>
In-Reply-To: <200805010216.m412GT6t004096@goober>
References: <200805010216.m412GT6t004096@goober>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 May 2008 12:16:29 +1000
Greg Ungerer <gerg@snapgear.com> wrote:

> Subject: [PATCH] m68knommu: ColdFire add support for kernel preemption

Please find a way to get your patch queue into linux-next so that others
get some visibility into what you're brewing earlier than
last-day-of-the-merge-window?

Also, when emailing patches like this I do think that it's best that they
be sequence-numbered, even if they are all non-overlapping and unrelated. 
Because it allows the recipient to check that none got lost.

Thanks.
