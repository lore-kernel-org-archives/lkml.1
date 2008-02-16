Return-Path: <linux-kernel-owner+w=401wt.eu-S1759522AbYBPSbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759522AbYBPSbS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 13:31:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752940AbYBPSbG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 13:31:06 -0500
Received: from www.tglx.de ([62.245.132.106]:49304 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753158AbYBPSbF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 13:31:05 -0500
Date: Sat, 16 Feb 2008 19:30:42 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Harvey Harrison <harvey.harrison@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: include prototype for no_broadcast in
 mach-default/setup.c
In-Reply-To: <1202848517.28953.11.camel@brick>
Message-ID: <alpine.LFD.1.00.0802161930240.7583@apollo.tec.linutronix.de>
References: <1202848517.28953.11.camel@brick>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Feb 2008, Harvey Harrison wrote:

> Fixes sparse warning:
> arch/x86/mach-default/setup.c:19:5: warning: symbol 'no_broadcast' was not declared. Should it be static?
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>

Applied. Thanks,

	 tglx
