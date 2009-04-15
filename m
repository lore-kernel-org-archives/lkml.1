Return-Path: <linux-kernel-owner+w=401wt.eu-S1753384AbZDORDa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384AbZDORDa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 13:03:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751794AbZDORDV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 13:03:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47683 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbZDORDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 13:03:20 -0400
Message-ID: <49E612A5.2010204@zytor.com>
Date: Wed, 15 Apr 2009 10:00:21 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Jones <davej@redhat.com>
Subject: Re: Fix quilt merge error in acpi-cpufreq.c
References: <200904140159.n3E1x1K1014705@hera.kernel.org> <20090414020544.GA3738@elte.hu> <20090415054417.GA5272@elte.hu> <200904152014.11717.rusty@rustcorp.com.au> <alpine.LFD.2.00.0904150822020.4132@localhost.localdomain> <20090415162627.GA32254@elte.hu> <49E60F7F.4020901@zytor.com>
In-Reply-To: <49E60F7F.4020901@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: fix meaning reversal

H. Peter Anvin wrote:
> 
> I generally find I spend about three times longer reviewing the same
> amount of code from someone who has written Impact: lines on their
> patches, mostly because it means they have thought about it.  It does
> get reflected in the rest of the patch.  Also, if they aren't there, I
> do end up writing them, and quite often find issues in the process.
> 

That should, of course, have been who has *not* written Impact: lines... ;)

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

