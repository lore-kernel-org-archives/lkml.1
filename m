Return-Path: <linux-kernel-owner+w=401wt.eu-S1762621AbXLUEu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762621AbXLUEu3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 23:50:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759250AbXLUEuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 23:50:08 -0500
Received: from there.is.no.cabal.ca ([134.117.69.58]:56669 "EHLO
	fattire.cabal.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754904AbXLUEuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 23:50:06 -0500
Date: Thu, 20 Dec 2007 23:50:05 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Junio C Hamano <gitster@pobox.com>, Git Mailing List <git@vger.kernel.org>,
       Raphael Assenat <raph@8d.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.24-rc6
Message-ID: <20071221045005.GF8535@fattire.cabal.ca>
References: <alpine.LFD.0.9999.0712201731010.21557@woody.linux-foundation.org> <20071221024805.GB8535@fattire.cabal.ca> <20071221030152.GC8535@fattire.cabal.ca> <alpine.LFD.0.9999.0712201937470.21557@woody.linux-foundation.org> <alpine.LFD.0.9999.0712202009290.21557@woody.linux-foundation.org> <alpine.LFD.0.9999.0712202026040.21557@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.9999.0712202026040.21557@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2007 at 08:40:54PM -0800, Linus Torvalds wrote:
> That was a rather long-winded explanation of what happened, mainly because 
> it was all very unexpected to me, and I had personally mistakenly thought 
> the git optimization was perfectly valid and actually had to go through 
> the end result to see what was going on.
> 
> Anyway, the diff on kernel.org should be all ok now, and mirrored out too.
> 

Thanks again for being so quick to track this down, applies fine and is
out for building in rawhide now.

cheers, Kyle
