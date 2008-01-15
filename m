Return-Path: <linux-kernel-owner+w=401wt.eu-S1756790AbYAOUNg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756790AbYAOUNg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 15:13:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752696AbYAOUNZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 15:13:25 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55690 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752868AbYAOUNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 15:13:24 -0500
Date: Tue, 15 Jan 2008 12:10:53 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Sam Ravnborg <sam@ravnborg.org>, Russell King <rmk+lkml@arm.linux.org.uk>,
       Adrian Bunk <adrian.bunk@movial.fi>,
       Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, phil.el@wanadoo.fr,
       oprofile-list@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: Fwd: Re: [2.6.24 patch] restore ARMv6 OProfile support
In-Reply-To: <20080115190719.GA12236@Krystal>
Message-ID: <alpine.LFD.1.00.0801151210170.2806@woody.linux-foundation.org>
References: <20071228195841.GA3945@flint.arm.linux.org.uk> <20080115104526.GA32067@flint.arm.linux.org.uk> <alpine.LFD.1.00.0801150811250.2806@woody.linux-foundation.org> <20080115173701.GB8375@Krystal> <alpine.LFD.1.00.0801151051120.2806@woody.linux-foundation.org>
 <20080115190719.GA12236@Krystal>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 15 Jan 2008, Mathieu Desnoyers wrote:
> 
> Furthermore, on ARM, the OPROFILE_ARMV6, OPROFILE_MPCORE and
> OPROFILE_ARM11_CORE are all "bool , default y" (equivalent to the
> preferred def_bool y).

Ahh, I didn't notice that. If so, yes, it doesn't matter at all whether 
it's inside the menu or not, of course.

		Linus
