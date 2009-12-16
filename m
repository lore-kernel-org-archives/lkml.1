Return-Path: <linux-kernel-owner+w=401wt.eu-S1755537AbZLPOvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537AbZLPOvX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 09:51:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750809AbZLPOvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 09:51:22 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:47966 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742AbZLPOvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 09:51:21 -0500
Date: Wed, 16 Dec 2009 09:51:20 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: anyone including <linux/perf_counter.h>?
Message-ID: <20091216145120.GL28962@bombadil.infradead.org>
References: <alpine.LFD.2.00.0912160939510.7588@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0912160939510.7588@localhost>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 16, 2009 at 09:42:50AM -0500, Robert P. J. Day wrote:
> 
>   just prepping to run my cleanup suggestion scripts after the merge
> window closes, quick test run on some scripts and ran across the fact
> that no one appears to be including <linux/perf_counter.h>.
> 
>   any value to that file?  just curious.  much more pedantry after the
> merge window, of course.
> 

See the comment at the top, it's being provided to provide the old names
to userspace for a short time, now that the functionality has been renamed
to perf_events.

--kyle
