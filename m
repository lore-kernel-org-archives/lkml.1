Return-Path: <linux-kernel-owner+w=401wt.eu-S1759078AbYBPSLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759078AbYBPSLT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 13:11:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752644AbYBPSLD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 13:11:03 -0500
Received: from www.tglx.de ([62.245.132.106]:43545 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751484AbYBPSLA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 13:11:00 -0500
Date: Sat, 16 Feb 2008 19:10:36 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Harvey Harrison <harvey.harrison@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] x86: sparse warning in efi.c
In-Reply-To: <1202937973.18204.6.camel@brick>
Message-ID: <alpine.LFD.1.00.0802161909520.7583@apollo.tec.linutronix.de>
References: <1202937973.18204.6.camel@brick>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Feb 2008, Harvey Harrison wrote:

> arch/x86/kernel/efi.c:57:12: warning: symbol 'efi_phys' was not declared. Should it be static?
> 
> Yes, it should.
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>

Applied. Thanks,

	 tglx
