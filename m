Return-Path: <linux-kernel-owner+w=401wt.eu-S1752822AbXJWWHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822AbXJWWHd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 18:07:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753162AbXJWWHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 18:07:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57140 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884AbXJWWHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 18:07:03 -0400
Message-ID: <471E7078.4050908@zytor.com>
Date: Tue, 23 Oct 2007 15:06:48 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: "Huang, Ying" <ying.huang@intel.com>
CC: Andi Kleen <ak@suse.de>, "Eric W. Biederman" <ebiederm@xmission.com>,
       akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -v7 0/3] x86 boot: 32-bit boot protocol
References: <1193126765.23935.74.camel@caritas-dev.intel.com>
In-Reply-To: <1193126765.23935.74.camel@caritas-dev.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Huang, Ying wrote:
> This patch set defines a 32-bit boot protocol for x86 platform, adds
> an extensible boot parameter passing mechanism, export the boot
> parameters via sysfs.
> 
> The patch set has been tested against kernel of git version
> v2.6.23-6623-g55b70a0 (with Rusty's git tree pulled) on x86_64 and
> i386.
> 
> This patch set is based on the proposal of Peter Anvin.
> 

Acked-by: H. Peter Anvin <hpa@zytor.com>

This patchset should spend a cycle in -mm before being merged, though.

	-hpa
