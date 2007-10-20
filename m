Return-Path: <linux-kernel-owner+w=401wt.eu-S1763864AbXJTKuz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763864AbXJTKuz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 06:50:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756247AbXJTKur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 06:50:47 -0400
Received: from www.tglx.de ([62.245.132.106]:38632 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756018AbXJTKur (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 06:50:47 -0400
Date: Sat, 20 Oct 2007 12:50:40 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Chris Snook <csnook@redhat.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: merge mmu{,_32,_64}.h
In-Reply-To: <20071020065659.GA12404@shell.boston.redhat.com>
Message-ID: <alpine.LFD.0.9999.0710201250170.22770@localhost.localdomain>
References: <20071020065659.GA12404@shell.boston.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Oct 2007, Chris Snook wrote:

> From: Chris Snook <csnook@redhat.com>
> 
> Merge mmu_32.h and mmu_64.h into mmu.h.
> 
> Signed-off-by: Chris Snook <csnook@redhat.com>

Applied. Thanks,

	 tglx
