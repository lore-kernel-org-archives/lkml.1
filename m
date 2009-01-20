Return-Path: <linux-kernel-owner+w=401wt.eu-S1756729AbZATFLr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756729AbZATFLr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 00:11:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750810AbZATFLi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 00:11:38 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60080 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750816AbZATFLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 00:11:37 -0500
Date: Tue, 20 Jan 2009 16:11:15 +1100 (EST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Nick Piggin <npiggin@suse.de>
cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] x86: optimise page fault entry
In-Reply-To: <20090120032426.GE16304@wotan.suse.de>
Message-ID: <alpine.LFD.2.00.0901201605280.2915@localhost.localdomain>
References: <20090120032426.GE16304@wotan.suse.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 20 Jan 2009, Nick Piggin wrote:
> 
> Optimise x86's do_page_fault (C entry point for the page fault path).

Acked-by: Linus Torvalds <torvalds@linux-foundation.org>

		Linus
