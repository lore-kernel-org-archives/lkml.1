Return-Path: <linux-kernel-owner+w=401wt.eu-S1756706AbYCKNBn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756706AbYCKNBn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 09:01:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753295AbYCKNBe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 09:01:34 -0400
Received: from rn-out-0910.google.com ([64.233.170.184]:50832 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbYCKNBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 09:01:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=aRwMybLtQ5z2wl3VgJi3MaCTWsoHv7UT04CVSHD8WHZ8xoNwTMcBboricxiWI+cOVECdNH8bielLqIYGlAcNnAFtaKAyh4fOsSuerGkzv5OoD1bYzw+Ergcf9HkbvjPy1XXJ5TNIIUHsOeDLRMND6vLQl+Fo86VeKzC8noiZoV0=
Message-ID: <4d8e3fd30803110601j612e24a6gd3d9a36d8e447b55@mail.gmail.com>
Date: Tue, 11 Mar 2008 14:01:31 +0100
From: "Paolo Ciarrocchi" <paolo.ciarrocchi@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 0/2] x86: coding style fixes to arch/x86/kernel/setup_32.c
Cc: hpa <hpa@zytor.com>, tglx <tglx@linutronix.de>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080311123150.GB10343@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080307192459.52c0a330@paolo-desktop>
	 <4d8e3fd30803110503n28692bcbt3f0ef3b94f4a3805@mail.gmail.com>
	 <20080311123150.GB10343@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2008 at 1:31 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
>  * Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com> wrote:
>
>  > On 3/7/08, Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com> wrote:
>  > > Compile tested, patch #2 depends on #1
>  > >
>  > > Paolo Ciarrocchi (2):
>  > > x86: coding style fixes to arch/x86/kernel/setup_32.c
>  > > x86: coding style fixes to arch/x86/kernel/setup_32.c
>  > >
>  > > arch/x86/kernel/setup_32.c | 9 ++++-----
>  > > 1 files changed, 4 insertions(+), 5 deletions(-)
>  >
>  > hi Ingo, all,
>  > i think i didn't get any feedback, do you want me to submit again?
>
>  should all be in latest x86.git. Did i miss any of them? [i only picked
>  up one because the other was already handled iirc]

I now see the patch here:
http://git.kernel.org/?p=linux/kernel/git/x86/linux-2.6-x86.git;a=shortlog;h=latest
When I wrote the patch gitweb was not showing it :-)

Thanks.

Ciao,
-- 
Paolo
http://paolo.ciarrocchi.googlepages.com/
