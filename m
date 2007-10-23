Return-Path: <linux-kernel-owner+w=401wt.eu-S1752815AbXJWF07@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815AbXJWF07 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 01:26:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751763AbXJWF0u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 01:26:50 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:41461
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734AbXJWF0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 01:26:49 -0400
Date: Mon, 22 Oct 2007 22:32:24 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Crispin Cowan <crispin@crispincowan.com>
cc: Greg KH <greg@kroah.com>, Thomas Fricaccia <thomas_fricacci@yahoo.com>,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LSM ML <linux-security-module@vger.kernel.org>
Subject: Re: LSM conversion to static interface
In-Reply-To: <471D834B.1080501@crispincowan.com>
Message-ID: <Pine.LNX.4.64.0710222230250.15763@asgard.lang.hm>
References: <200710221700.l9MH0klg006152@sapphire.spiritone.com>
 <20071022171326.GA30317@kroah.com> <471D834B.1080501@crispincowan.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Oct 2007, Crispin Cowan wrote:

>
> Suffice it to say that there are a variety of reasons why someone either
> cannot re-compile a kernel, or just does not want to recompile a kernel.
> This change to LSM removes their choice to use modules others than those
> provided by their distro vendor.
>
one reason to not be willing to rebuild the kernel is that they may rely 
on a module from a different third party that is shipped/tested for the 
specific pre-compiled kernels from the distro.

David Lang
