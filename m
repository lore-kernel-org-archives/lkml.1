Return-Path: <linux-kernel-owner+w=401wt.eu-S1753908AbXDJVZ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908AbXDJVZ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 17:25:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753912AbXDJVZ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 17:25:56 -0400
Received: from waste.org ([66.93.16.53]:40236 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753908AbXDJVZz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 17:25:55 -0400
Date: Tue, 10 Apr 2007 16:09:14 -0500
From: Matt Mackall <mpm@selenic.com>
To: Adrian Bunk <bunk@stusta.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [-mm patch] make struct proc_kpagemap static
Message-ID: <20070410210914.GC11115@waste.org>
References: <20070408143559.f5014629.akpm@linux-foundation.org> <20070410210826.GI28370@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070410210826.GI28370@stusta.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 10, 2007 at 11:08:26PM +0200, Adrian Bunk wrote:
> On Sun, Apr 08, 2007 at 02:35:59PM -0700, Andrew Morton wrote:
> >...
> > Changes since 2.6.21-rc5-mm4:
> >...
> > +maps2-add-proc-kpagemap-interface.patch
> > 
> >  New interfaces for inspecting process memory status
> >...
> 
> 
> This patch makes the needlessly global truct proc_kpagemap static.
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>
Acked-by: Matt Mackall <mpm@selenic.com>

-- 
Mathematics is the supreme nostalgia of our time.
