Return-Path: <linux-kernel-owner+w=401wt.eu-S1762643AbXGZFnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762643AbXGZFnT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 01:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753487AbXGZFnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 01:43:12 -0400
Received: from nz-out-0506.google.com ([64.233.162.239]:29853 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469AbXGZFnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 01:43:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=eeUOVt73/LUNzJPqSCvuPPSfEGUs6KG7PV2JFF4lTsJuQWd5pTkB4DlxnbhV/2JBiHa9e2RaZDAkObar76HzGaZWzZHSlKhsZ8qaipeqZQxwidk0SBp6w+AXd0WgqJwX127e+Yzvja8RBMWssoNftzOOimj4CENEMakAUGmeIo4=
Message-ID: <4104961b0707252243l41addce8wca35d19c5de729ee@mail.gmail.com>
Date: Thu, 26 Jul 2007 13:43:10 +0800
From: "jidong xiao" <jidong.xiao@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: What's does KPROBE_ENTRY mean?
In-Reply-To: <4104961b0706202213p16df5ca5s579de4b949efbf16@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4104961b0706202213p16df5ca5s579de4b949efbf16@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Anyone can help this?

On 6/21/07, jidong xiao <jidong.xiao@gmail.com> wrote:
> I searched in linux kernel 2.6.10, didn't find it, then I tried
> 2.6.20, it is there. But I am not familiar with assembly language, so
> can anybody kindly explain it, I don't know the difference between
> KPROBE_ENTRY and ENTRY, however, I can find both of these items in
> some files, such as arch/x86_64/kernel/entry.S.
>
> Thank you.
>
> Regards
> Jason Xiao
>
