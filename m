Return-Path: <linux-kernel-owner+w=401wt.eu-S1753894AbYE2Ke3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894AbYE2Ke3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 06:34:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751003AbYE2KeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 06:34:21 -0400
Received: from styx.suse.cz ([82.119.242.94]:46098 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750780AbYE2KeU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 06:34:20 -0400
Date: Thu, 29 May 2008 12:34:19 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Chris Mason <chris.mason@oracle.com>
cc: ksummit-2008-discuss@lists.linux-foundation.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [Ksummit-2008-discuss] Fixing the Kernel Janitors project
In-Reply-To: <200805281615.55386.chris.mason@oracle.com>
Message-ID: <Pine.LNX.4.64.0805291224470.6718@jikos.suse.cz>
References: <1211995212.3445.52.camel@localhost.localdomain>
 <20080528150837.685aa677@bree.surriel.com> <200805281615.55386.chris.mason@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 May 2008, Chris Mason wrote:

> One motivation here is to bring bug reporters from active distro 
> communities into testing mainline kernels as well.

My experience from handling both distro-reported and upstream-reported 
bugs shows that these two worlds/communitites are really quite different 
in their nature.

Bug reporters who report bug in the vanilla kernel are usually perfectly 
fine when someone sends them patch to test, they don't have any problem 
recompiling the patched kernel, testing, and reporting back.

This is not the case with distro kernel bug reporters at all. You usually 
can't just tell them "hey, this patch might fix it, report back if it 
does". Vast majority of theese users expect the kernel package built for 
their distro to be provided, so that they can easily install it and test 
it, but requiring any other effort usually doesn't work.

Just my $0.02.

-- 
Jiri Kosina
SUSE Labs
