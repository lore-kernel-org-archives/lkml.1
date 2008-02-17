Return-Path: <linux-kernel-owner+w=401wt.eu-S1758428AbYBQOCJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758428AbYBQOCJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 09:02:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758121AbYBQOBq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 09:01:46 -0500
Received: from www.tglx.de ([62.245.132.106]:42471 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756881AbYBQOBp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 09:01:45 -0500
Date: Sun, 17 Feb 2008 15:01:32 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Harvey Harrison <harvey.harrison@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: include prototype for no_broadcast in
 mach-default/setup.c
In-Reply-To: <1202848517.28953.11.camel@brick>
Message-ID: <alpine.LFD.1.00.0802171501110.7583@apollo.tec.linutronix.de>
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

Applied. Thanks,

	 tglx
