Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751473Ab0APGRr (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 16 Jan 2010 01:17:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751240Ab0APGRq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 01:17:46 -0500
Received: from snt0-omc2-s6.snt0.hotmail.com ([65.55.90.81]:38284 "EHLO
	snt0-omc2-s6.snt0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751210Ab0APGRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 01:17:46 -0500
X-Originating-IP: [96.253.143.208]
X-Originating-Email: [yuhongbao_386@hotmail.com]
Message-ID: <SNT125-DS19339D7DE9CFA33C1D54AC3680@phx.gbl>
From: <yuhongbao_386@hotmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>, <mingo@redhat.com>,
        <linux-kernel@vger.kernel.org>, <kernel-team@lists.ubuntu.com>
References: <SNT125-W41CEF6892DBE0B1FD99B4AC3780@phx.gbl>,<4B511B12.6010208@zytor.com> <SNT125-W39A63687E4BE4F52FAA517C3680@phx.gbl> <4B514656.5080805@zytor.com>
In-Reply-To: <4B514656.5080805@zytor.com>
Subject: Re: Ubuntu 32-bit, 32-bit PAE, 64-bit Kernel Benchmarks
Date: Fri, 15 Jan 2010 22:17:41 -0800
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="UTF-8";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
Importance: Normal
X-Mailer: Microsoft Windows Live Mail 14.0.8089.726
X-MimeOLE: Produced By Microsoft MimeOLE V14.0.8089.726
X-OriginalArrivalTime: 16 Jan 2010 06:17:45.0923 (UTC) FILETIME=[9E91A130:01CA9673]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Since 32 bits means that any machine with 1 GB more means HIGHMEM, the
> number of non-embedded machines that should run 32-bit kernels today is
> functionally the null set.
You mean machines made today?
> Unfortunately Linux distros have not
> properly promoted 64-bit kernels for 32-bit distros; although pure 64
> bits is better, it would be a *helluva* lot better if people stuck on 32
> bits for compatibility reasons had a saner alternative.
Yep, I remember having to use --force-architecture to install the Linux 
kernel from the 64-bit version of Ubuntu into the 32-bit version.
As I remember, the package name was the same as the 32-bit version, causing 
confusion.
What led me to uninstall it, though, was that suspend/resume did not work 
properly.
I am adding a CC to the Ubuntu kernel team mailing list.

Yuhong Bao 

