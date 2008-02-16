Return-Path: <linux-kernel-owner+w=401wt.eu-S1758859AbYBPSaF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758859AbYBPSaF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 13:30:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752764AbYBPS3z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 13:29:55 -0500
Received: from www.tglx.de ([62.245.132.106]:49243 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751890AbYBPS3z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 13:29:55 -0500
Date: Sat, 16 Feb 2008 19:29:37 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Harvey Harrison <harvey.harrison@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: pit_clockevent can be static
In-Reply-To: <1202847027.28953.4.camel@brick>
Message-ID: <alpine.LFD.1.00.0802161929180.7583@apollo.tec.linutronix.de>
References: <1202847027.28953.4.camel@brick>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Feb 2008, Harvey Harrison wrote:

> arch/x86/kernel/i8253.c:98:27: warning: symbol 'pit_clockevent' was not declared. Should it be static?
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>

Applied. Thanks,

	 tglx
