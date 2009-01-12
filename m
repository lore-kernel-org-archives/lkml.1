Return-Path: <linux-kernel-owner+w=401wt.eu-S1755683AbZALRps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755683AbZALRps (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 12:45:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751300AbZALRpf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 12:45:35 -0500
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:36351
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755210AbZALRpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 12:45:34 -0500
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Peter Korsgaard <jacmet@sunsite.dk>
Subject: Re: PATCH [0/3]: Simplify the kernel build by removing perl.
Date: Mon, 12 Jan 2009 11:45:28 -0600
User-Agent: KMail/1.10.1 (Linux/2.6.27-9-generic; KDE/4.1.2; x86_64; ; )
Cc: "Mark A. Miller" <mark@mirell.org>, "Bernd Petrovitsch" <bernd@firmix.at>,
       "Leon Woestenberg" <leon.woestenberg@gmail.com>,
       "Paul Mundt" <lethal@linux-sh.org>, "H. Peter Anvin" <hpa@zytor.com>,
       "Embedded Linux mailing list" <linux-embedded@vger.kernel.org>,
       linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Sam Ravnborg" <sam@ravnborg.org>
References: <200901020207.30359.rob@landley.net> <31014a580901111936q41486efagcb90af2b6880a470@mail.gmail.com> <873afpj5e3.fsf@macbook.be.48ers.dk>
In-Reply-To: <873afpj5e3.fsf@macbook.be.48ers.dk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901121145.29215.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 January 2009 02:27:32 Peter Korsgaard wrote:
> >>>>> "Mark" == Mark A Miller <mark@mirell.org> writes:
>
>  Mark> And for H. Peter Anvin, before you refer to such uses as compiling
> the Mark> kernel under a native environment as a "piece of art", please be
> aware Mark> that the mainstream embedded development environment,
> buildroot, is Mark> also attempting to utilize QEMU for a "sanity check" on
> the Mark> environment.
>
> That's for verifying that the rootfs'es actually work, not for
> building stuff.

Not in my case.

Rob
