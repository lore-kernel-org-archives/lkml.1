Return-Path: <linux-kernel-owner+w=401wt.eu-S1759034AbZFIIwn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759034AbZFIIwn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 04:52:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755824AbZFIIwf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 04:52:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:43983 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754564AbZFIIwe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 04:52:34 -0400
Subject: Re: [PATCH] X86: cpu_debug support for VIA / Centaur CPU's
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Harald Welte <HaraldWelte@viatech.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20090609082931.GD25316@prithivi.gnumonks.org>
References: <20090609082931.GD25316@prithivi.gnumonks.org>
Content-Type: text/plain
Date: Tue, 09 Jun 2009 14:23:18 +0530
Message-Id: <1244537598.2558.9.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Harald,

On Tue, 2009-06-09 at 16:29 +0800, Harald Welte wrote:
> This patch adds the MSR definitions for the VIA/Centaur CPU models
> to cpu_debug.c
> 
> Signed-off-by: Harald Welte <HaraldWelte@viatech.com>

As per Ingo suggestion, we removed model information from cpu_debug and
is available in -tip :

http://git.kernel.org/?p=linux/kernel/git/x86/linux-2.6-tip.git;a=commitdiff;h=5095f59bda6793a7b8f0856096d6893fe98e0e51

Please check latest -tip from and see how it works with your chips :
git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-tip.git

Currently I am doing more changes and available in :

http://git.kernel.org/?p=linux/kernel/git/jaswinder/linux-2.6-cpu.git;a=shortlog;h=x86/cpu

Thanks,
--
JSR

