Return-Path: <linux-kernel-owner+w=401wt.eu-S1764191AbXJTKyN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764191AbXJTKyN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 06:54:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757171AbXJTKx7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 06:53:59 -0400
Received: from www.tglx.de ([62.245.132.106]:38713 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758149AbXJTKx6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 06:53:58 -0400
Date: Sat, 20 Oct 2007 12:53:52 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Chris Snook <csnook@redhat.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: unify a.out{,_32,_64}.h
In-Reply-To: <20071020103701.GA2728@shell.boston.redhat.com>
Message-ID: <alpine.LFD.0.9999.0710201252270.22770@localhost.localdomain>
References: <20071020103701.GA2728@shell.boston.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Oct 2007, Chris Snook wrote:

> From: Chris Snook <csnook@redhat.com>
> 
> Unify x86 a.out_32.h and a.out_64.h

The include/asm-x86/Kbuild fixup is missing. I fixed it up.

Applied. Thanks,

	 tglx
