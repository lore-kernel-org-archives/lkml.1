Return-Path: <linux-kernel-owner+w=401wt.eu-S1759262AbZGCTWz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759262AbZGCTWz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 15:22:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759029AbZGCTWg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 15:22:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42744 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759119AbZGCTWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 15:22:35 -0400
Message-ID: <4A4E5974.7030507@zytor.com>
Date: Fri, 03 Jul 2009 12:18:12 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: lkml@MoreThan.org, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Andi Kleen <ak@linux.intel.com>
Subject: Re: [Bug Fix]: Do 32-bit table calculations in pre-processor
References: <200907031314.36243.lkml@morethan.org> <4A4E54A8.4030606@goop.org> <200907031403.34566.lkml@morethan.org> <4A4E57FA.4000609@goop.org>
In-Reply-To: <4A4E57FA.4000609@goop.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> 
> Hm, well that does sound serious, but I think you're barking up the
> wrong tree with this particular patch.
> 

Well, if it changes behavior it's an indication that the version of gas
he's using is broken (or possibly very old.)  What version is it?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

