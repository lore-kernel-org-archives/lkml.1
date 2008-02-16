Return-Path: <linux-kernel-owner+w=401wt.eu-S1757978AbYBPSWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757978AbYBPSWu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 13:22:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752138AbYBPSWn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 13:22:43 -0500
Received: from www.tglx.de ([62.245.132.106]:48204 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752067AbYBPSWm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 13:22:42 -0500
Date: Sat, 16 Feb 2008 19:22:05 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Adrian Bunk <bunk@kernel.org>
cc: Roland McGrath <roland@redhat.com>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] x86: make mxcsr_feature_mask static again
In-Reply-To: <20080213212933.GE3383@cs181133002.pp.htv.fi>
Message-ID: <alpine.LFD.1.00.0802161921350.7583@apollo.tec.linutronix.de>
References: <20080213212933.GE3383@cs181133002.pp.htv.fi>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Feb 2008, Adrian Bunk wrote:

> mxcsr_feature_mask needlessly became global.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Applied. Thanks,

	 tglx
