Return-Path: <linux-kernel-owner+w=401wt.eu-S1757821AbYCKCNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757821AbYCKCNX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 22:13:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757518AbYCKCNG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 22:13:06 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:25496 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756068AbYCKCND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 22:13:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=pjrs9l0KzGNWVaafICyCnusSWWsnD/hgXdVsqTq8kEKsNTIbBQG2oHsSu+dFYmxSYVSGWE+8h5+jfqoDH6e0HxNxK1o3E2DILP+KnKuIzqe8UNNAesryfpJlAuyFqYDac2fKzKiqsvDGGNwj7Y+C5b0hOVVRkDFgYg0KzyDoj6g=
Message-ID: <93564eb70803101913n2ede72d1i33279772440c9afa@mail.gmail.com>
Date: Tue, 11 Mar 2008 11:13:02 +0900
From: "Samuel Masham" <samuel.masham@gmail.com>
To: stable@kernel.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-mips@vger.kernel.org, "Greg Kroah-Hartman" <gregkh@suse.de>
Subject: Re: 2.6.24 patches for mips qemu target needed for stable.
Cc: "Ralf Baechle" <ralf@linux-mips.org>, "Rob Landley" <rob@landley.net>
In-Reply-To: <93564eb70802241736l741e7406o29fab05a611c12c7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <93564eb70802241736l741e7406o29fab05a611c12c7@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stable, Greg, all,

Just a quick ping.

Still not seeing these on the stable queue? Any issue or am i just
looking in the wrong place:-

http://www.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git

2008/2/25 Samuel Masham <samuel.masham@gmail.com>:
>
>  46f4f8f665080900e865392f4b3593be463bf0d8 - IRQ_NOPROBE helper functions
>  24649c00ca334955ac7d8a79f5a7834fc7ea441d - MIPS: Mark all but i8259
>  interrupts as no-probe.
>
>  They have no impact on any other architecture so I hope are simple to
>  include in the stable tree.

thanks,

Samuel
