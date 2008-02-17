Return-Path: <linux-kernel-owner+w=401wt.eu-S1758356AbYBQOBu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758356AbYBQOBu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 09:01:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755401AbYBQOBm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 09:01:42 -0500
Received: from www.tglx.de ([62.245.132.106]:50182 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755285AbYBQOBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 09:01:41 -0500
Date: Sun, 17 Feb 2008 15:00:59 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Harvey Harrison <harvey.harrison@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Roland McGrath <roland@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/9] x86: change most X86_32 pt_regs members to unsigned
 long
In-Reply-To: <1202501396.12966.20.camel@brick>
Message-ID: <alpine.LFD.1.00.0802171500310.7583@apollo.tec.linutronix.de>
References: <1202501396.12966.20.camel@brick>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on Fri, 8 Feb 2008, Harvey Harrison wrote:

> All but ax and orig_ax can move with no changes.
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>

Applied. Thanks,

	 tglx
