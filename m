Return-Path: <linux-kernel-owner+w=401wt.eu-S1759544AbXIYRhc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759544AbXIYRhc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 13:37:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751507AbXIYRhZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 13:37:25 -0400
Received: from waste.org ([66.93.16.53]:58936 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750955AbXIYRhZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 13:37:25 -0400
Date: Tue, 25 Sep 2007 12:37:05 -0500
From: Matt Mackall <mpm@selenic.com>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Subbaiah Venkata <kvsnaidu@sapnaidu.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib/sort.c, 2.6.22 kernel
Message-ID: <20070925173705.GB17536@waste.org>
References: <000201c7da12$a1aec340$0a02a8c0@NetWin> <Pine.LNX.4.64.0709251652050.945@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0709251652050.945@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2007 at 04:52:47PM +0200, Jan Engelhardt wrote:
> 
> On Aug 8 2007 16:19, Subbaiah Venkata wrote:
> >
> >Hello, I fixed and tested a small bug in lib/sort.c file, heap sort
> >function.
> >
> >The fix avoids unnecessary swap of contents when i is 0 (saves few
> >loads and stores), which happens every time sort function is called.
> >I felt the fix is worth bringing it to your attention given the
> >importance and frequent use of the sort function.
> 
> Would you like to resubmit this? Please do ;)
> (I am hinting at Documentation/SubmittingPatches too..)

This is in -mm already.

-- 
Mathematics is the supreme nostalgia of our time.
