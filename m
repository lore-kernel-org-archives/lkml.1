Return-Path: <linux-kernel-owner+w=401wt.eu-S933734AbYCEXKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933734AbYCEXKl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 18:10:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932900AbYCEXHo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 18:07:44 -0500
Received: from mx2.suse.de ([195.135.220.15]:50532 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764972AbYCEXHm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 18:07:42 -0500
Date: Thu, 6 Mar 2008 00:07:39 +0100 (CET)
From: Michael Matz <matz@suse.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: David Miller <davem@davemloft.net>, richard.guenther@gmail.com,
       Joe.Buck@synopsys.com, hubicka@ucw.cz, aurelien@aurel32.net,
       linux-kernel@vger.kernel.org, gcc@gcc.gnu.org
Subject: Re: RELEASE BLOCKER: Linux doesn't follow x86/x86-64 ABI wrt direction
 flag
In-Reply-To: <47CF25A5.5060709@zytor.com>
Message-ID: <Pine.LNX.4.64.0803060006520.20583@wotan.suse.de>
References: <84fc9c000803051332q2f2eedeej7d3c0509e698cabf@mail.gmail.com>
 <47CF11D6.7070901@zytor.com> <84fc9c000803051340i13559c63tcf56eb828d000802@mail.gmail.com>
 <20080305.141622.80343656.davem@davemloft.net> <Pine.LNX.4.64.0803052341330.20583@wotan.suse.de>
 <47CF25A5.5060709@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 5 Mar 2008, H. Peter Anvin wrote:

> Michael Matz wrote:
> > 
> > Many bugs are a big issue to people who actually hit them, and we had (and
> > probably still have) far nastier corner case miscompilations here and there
> > and nevertheless released.  It never was the end of the world :)
> > 
> 
> This is the sort of stuff that security holes are made from.

For security problems I prefer fixes over work-arounds.  The fix lies in 
the kernel, the work-around in gcc.


Ciao,
Michael.
