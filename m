Return-Path: <linux-kernel-owner+w=401wt.eu-S1759358AbYBPSZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759358AbYBPSZc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 13:25:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752940AbYBPSZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 13:25:18 -0500
Received: from www.tglx.de ([62.245.132.106]:48296 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753036AbYBPSZR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 13:25:17 -0500
Date: Sat, 16 Feb 2008 19:24:30 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Adrian Bunk <bunk@kernel.org>
cc: Ian Campbell <ijc@hellion.org.uk>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] x86: don't make swapper_pg_fixmap global
In-Reply-To: <20080213212955.GP3383@cs181133002.pp.htv.fi>
Message-ID: <alpine.LFD.1.00.0802161924150.7583@apollo.tec.linutronix.de>
References: <20080213212955.GP3383@cs181133002.pp.htv.fi>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Feb 2008, Adrian Bunk wrote:
> It's not required for swapper_pg_fixmap to be global.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Applied. Thanks,

	 tglx
