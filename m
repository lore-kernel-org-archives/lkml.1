Return-Path: <linux-kernel-owner+w=401wt.eu-S1757350AbXGLRu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757350AbXGLRu1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 13:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753907AbXGLRuP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 13:50:15 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42589 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753756AbXGLRuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 13:50:13 -0400
Date: Thu, 12 Jul 2007 10:49:53 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: "H. Peter Anvin" <hpa@zytor.com>, andi@firstfloor.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: x86 setup code rewrite in C - revised
In-Reply-To: <20070712103056.52126a96.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.0.999.0707121049380.20061@woody.linux-foundation.org>
References: <1184181538674-git-send-email-hpa@zytor.com>
 <alpine.LFD.0.999.0707121016210.20061@woody.linux-foundation.org>
 <20070712103056.52126a96.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 12 Jul 2007, Andrew Morton wrote:
> 
> This code has been in -mm since 11 May, as git-newsetup.patch.  It has
> caused (for what it is) astonishingly few problems.  Maybe a couple of
> build glitches and one runtime failure, all quickly fixed.
> 
> I'd say it's ready.

Ok. That makes it easy. I'll just merge it.

		Linus
