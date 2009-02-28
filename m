Return-Path: <linux-kernel-owner+w=401wt.eu-S1754585AbZB1SRn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585AbZB1SRn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 13:17:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753193AbZB1SRe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 13:17:34 -0500
Received: from one.firstfloor.org ([213.235.205.2]:50502 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779AbZB1SRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 13:17:34 -0500
To: Jody Belka <lists-xen@pimb.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] xen: core dom0 support
From: Andi Kleen <andi@firstfloor.org>
References: <1235786365-17744-1-git-send-email-jeremy@goop.org>
	<20090227212812.26d02f34.akpm@linux-foundation.org>
	<49A8DF28.4050301@goop.org>
	<200902282309.07576.nickpiggin@yahoo.com.au>
	<20090228181115.GU2056@pimb.org>
Date: Sat, 28 Feb 2009 19:15:38 +0100
In-Reply-To: <20090228181115.GU2056@pimb.org> (Jody Belka's message of "Sat, 28 Feb 2009 18:11:15 +0000")
Message-ID: <871vti2zsl.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jody Belka <lists-xen@pimb.org> writes:
>
> Is it duplication though? I personally have machines with older processors
> that don't have hvm support. I plan on keeping these around for a good amount
> of time, and would love to be running them on mainline. So for me, unless KVM
> is somehow going to support para-virtualisation, this isn't duplication.

The old systems will continue to run fine with a 2.6.18 Dom0 though.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
