Return-Path: <linux-kernel-owner+w=401wt.eu-S1752072AbXAaC1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072AbXAaC1c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 21:27:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752123AbXAaC1c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 21:27:32 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:41032 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072AbXAaC1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 21:27:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rxKjK5xDXtu9BrKPNK8tEfGJcToOKeNLCDtlsiJmn5P/OzPEwq6BA22+7Kenx/VhQR3coYl7pUvjusSmKFV8Q1Bdnrpzlg/QbjGmXoJ9mY97UVROD1fNhWrGGFcBfDS2wvD0lW7on+TvI2BhWL6Po396Nqvkr+mylMY0lIBFJ3c=
Message-ID: <f2b55d220701301827h703d24eele941c86046caa9e7@mail.gmail.com>
Date: Tue, 30 Jan 2007 18:27:29 -0800
From: "Michael K. Edwards" <medwards.linux@gmail.com>
To: "Greg KH" <greg@kroah.com>
Subject: Re: Free Linux Driver Development!
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070130012904.GA9617@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070130012904.GA9617@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/29/07, Greg KH <greg@kroah.com> wrote:
> Free Linux Driver Development!
>
> Yes, that's right, the Linux kernel community is offering all companies
> free Linux driver development.  ...
[snip]
> [1] for the CPUs that support the bus types that your device works on.

Bravo!  Now, is there a message in the same spirit that can be
tailored to embedded space, especially to SoC vendors and (even more
importantly) their customers?  Something along the lines of:

"We understand that embedded hardware is frequently buggy and that SoC
vendors are doing well if their own internal software people can get
enough help from the chip guys to bring up enough customer-driven use
cases to win a few design-ins.

We sympathize with embedded developers who stay up nights with an
O-scope and a JTAG emulator reverse-engineering the hardware behavior,
trying to figure out which this order of operations works and this
other one doesn't.

We have the software tools and the competence to quantify the
potential gains from current toolchains and kernels, aggressive
compilation options, and in-tree power/latency management strategies,
so that you can build a business case against "fire and forget" SDKs
based on ancient compilers, obsolete kernels, and unmaintained
out-of-tree patches.

We will help platform integrators bridge the gap between the chip
architects' claims about device performance and the condition in which
the BSP guys toss drivers over the fence.

You can hang onto the hardware and profit from coaching and code
review, or you can send us a board and whatever doco you've got, and
we'll figure it out.

All we ask is that 1) SoC vendors authorize customers to do an NDA
with OSDL and pass vendor NDA material along to us; 2) when the
product ships, all participants are free to exercise GPL rights with
respect to the chip support and driver code produced; and 3) platform
integrators cooperate with the rework usually needed as code merges
towards Linus's tree."

Or is this a pipe dream?

Cheers,
- Michael
