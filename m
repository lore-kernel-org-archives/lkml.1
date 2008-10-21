Return-Path: <linux-kernel-owner+w=401wt.eu-S1756259AbYJUWqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756259AbYJUWqU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 18:46:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751838AbYJUWqL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 18:46:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50508 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751706AbYJUWqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 18:46:10 -0400
Date: Tue, 21 Oct 2008 15:45:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dean Nelson <dcn@sgi.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/4] sgi-xp: add low-level hardware specific
 functionality
Message-Id: <20081021154500.7ea5b369.akpm@linux-foundation.org>
In-Reply-To: <20081021212054.GB14386@sgi.com>
References: <20081021212054.GB14386@sgi.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Oct 2008 16:20:54 -0500
Dean Nelson <dcn@sgi.com> wrote:

> This patchset adds some low-level hardware specific functionality to the
> xp/xpc drivers.
> 
> To build cleanly this patchset is dependent on the following patches
> submitted by Russ Anderson <rja@sgi.com>.
> 
> [PATCH] x86: Use consistent names for region size and conherence id on x86 and ia64.
>  (see http://marc.info/?l=linux-kernel&m=122461625304772&w=2)
> 
> [PATCH 1/3] x86: Add UV watchlist bios call
>  (see http://marc.info/?l=linux-kernel&m=122461934110503&w=2)
> [PATCH 2/3] x86: Add UV memory protection bios call
>  (see http://marc.info/?l=linux-kernel&m=122461934110506&w=2)
> [PATCH 3/3] x86: Add UV reserved page bios call
>  (see http://marc.info/?l=linux-kernel&m=122461934210509&w=2)
> 
> [PATCH] Add UV watchlist support
>  (see http://marc.info/?l=linux-ia64&m=122462371418298&w=2)

OK, so I need to go into hiding until/unless those patches turn up in
linux-next.

Please poke me if I forget.
