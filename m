Return-Path: <linux-kernel-owner+w=401wt.eu-S1752953AbXJVIta@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953AbXJVIta (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 04:49:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751439AbXJVItX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 04:49:23 -0400
Received: from www.tglx.de ([62.245.132.106]:46917 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751258AbXJVItW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 04:49:22 -0400
Date: Mon, 22 Oct 2007 10:48:59 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Adrian Bunk <bunk@kernel.org>
cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [2.6 patch] x86: add instrumentation menu
In-Reply-To: <20071022024808.GK30533@stusta.de>
Message-ID: <alpine.LFD.0.9999.0710221048090.22770@localhost.localdomain>
References: <20071022024808.GK30533@stusta.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Oct 2007, Adrian Bunk wrote:

> It seems commit 09cadedbdc01f1a4bea1f427d4fb4642eaa19da9 was incomplete 
> due to a clash with the x86 architecture merge.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Applied, thanks. Will go Linus wards with our next pull request.

	 tglx

