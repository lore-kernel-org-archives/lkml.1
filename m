Return-Path: <linux-kernel-owner+w=401wt.eu-S1756595AbXJJUEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756595AbXJJUEW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 16:04:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755413AbXJJUEP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 16:04:15 -0400
Received: from ns1.suse.de ([195.135.220.2]:54407 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755147AbXJJUEN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 16:04:13 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: =?iso-8859-1?q?Ren=E9_Rebe?= <rene@exactcode.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.23
References: <alpine.LFD.0.999.0710091346490.5039@woody.linux-foundation.org>
	<200710100944.16378.rene@exactcode.de> <20071010191413.GB3589@elte.hu>
From: Andi Kleen <andi@firstfloor.org>
Date: 10 Oct 2007 22:04:11 +0200
In-Reply-To: <20071010191413.GB3589@elte.hu>
Message-ID: <p73abqq7n44.fsf@molitor.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:
 
> your superblock build failure would be a new and so far unknown build 
> breakage variant - please send the .config you used, and double-check 
> that it's indeed a vanilla 2.6.23 tree.

It is not -- my 2.6.23 tree doesn't have the prototype that broke
the build for him.

-Andi
