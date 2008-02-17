Return-Path: <linux-kernel-owner+w=401wt.eu-S1758765AbYBQODv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758765AbYBQODv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 09:03:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755401AbYBQODo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 09:03:44 -0500
Received: from www.tglx.de ([62.245.132.106]:42558 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755332AbYBQODn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 09:03:43 -0500
Date: Sun, 17 Feb 2008 15:03:21 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86_64: remove never used nodenumer in pda
In-Reply-To: <200802162302.04131.yinghai.lu@sun.com>
Message-ID: <alpine.LFD.1.00.0802171502471.7583@apollo.tec.linutronix.de>
References: <200802162302.04131.yinghai.lu@sun.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Feb 2008, Yinghai Lu wrote:

> we don't need copy too. already have x86_cpu_to_node_map
> 
> Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

Applied. Thanks,

	 tglx
