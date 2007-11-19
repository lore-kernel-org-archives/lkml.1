Return-Path: <linux-kernel-owner+w=401wt.eu-S1754027AbXKSQes@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027AbXKSQes (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 11:34:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752708AbXKSQej
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 11:34:39 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:50100 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730AbXKSQej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 11:34:39 -0500
Date: Mon, 19 Nov 2007 09:34:38 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: David Ronis <ronis@ronispc.chem.mcgill.ca>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23.1->2.6.23.8 breaks root Makefile
Message-ID: <20071119163437.GD12494@parisc-linux.org>
References: <1195489140.21337.10.camel@ronispc.chem.mcgill.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1195489140.21337.10.camel@ronispc.chem.mcgill.ca>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 19, 2007 at 11:19:00AM -0500, David Ronis wrote:
> The current main Makefile incorrectly identified my ld as one that
> supports --build-id (it didn't).  The problem is fixed by upgrading to
> the latest binutils, version 2.18, which does, but somehow  I suspect
> that this wasn't what was intended.  For what it's worth, I was running
> with slackware's binutils-2.17.50.0.17.

That's not something that the janitors are responsible for.  Redirecting
to linux-kernel.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
