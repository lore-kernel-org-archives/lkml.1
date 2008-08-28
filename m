Return-Path: <linux-kernel-owner+w=401wt.eu-S1756513AbYH1ULX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756513AbYH1ULX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 16:11:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753829AbYH1ULP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 16:11:15 -0400
Received: from gw.goop.org ([64.81.55.164]:59953 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751844AbYH1ULP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 16:11:15 -0400
Message-ID: <48B70660.5020003@goop.org>
Date: Thu, 28 Aug 2008 13:11:12 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: the arch/x86 maintainers <x86@kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Austin Zhang <austin_zhang@linux.intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Cleanup and updates of x86 CPU definitions
References: <48B629D2.7040809@zytor.com>
In-Reply-To: <48B629D2.7040809@zytor.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> +#define X86_FEATURE_VMX		(4*32+ 5) /* Hardware virtualization */
> +#define X86_FEATURE_SMX		(4*32+ 6) /* "Safer" mode */
>   
Is this supposed to appear as "Safer" in /proc/cpuinfo?  Or should this
be ``Safer''?

    J
