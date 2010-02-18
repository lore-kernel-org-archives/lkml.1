Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751828Ab0BRX75 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 18:59:57 -0500
Received: from borg.medozas.de ([188.40.89.202]:59251 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750950Ab0BRX74 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 18:59:56 -0500
Date: Fri, 19 Feb 2010 00:59:54 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: Andi Kleen <andi@firstfloor.org>
cc: Phillip Lougher <phillip@lougher.demon.co.uk>,
       Jean Delvare <khali@linux-fr.org>, lasse.collin@tukaani.org,
       linux-kernel <linux-kernel@vger.kernel.org>, mirrors@kernel.org,
       users@kernel.org, "FTPAdmin Kernel.org" <ftpadmin@kernel.org>,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: [kernel.org users] XZ Migration discussion
In-Reply-To: <20100214095607.GB21783@one.firstfloor.org>
Message-ID: <alpine.LSU.2.01.1002190057090.1233@obet.zrqbmnf.qr>
References: <4B744E13.8040004@kernel.org> <20100211205129.GA26105@elf.ucw.cz> <20100213181008.479509f5@hyperion.delvare> <4B773B31.1020802@lougher.demon.co.uk> <20100214095607.GB21783@one.firstfloor.org>
User-Agent: Alpine 2.01 (LSU 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 2010-02-14 10:56, Andi Kleen wrote:

>> With xz you have just one C/C++ implementation with a single library with
>> an undocumented API for C/C++ programmers.
>
>... which is not even widely deployed. I did a quick survey and none of 
>my systems (none of which terrible old and not particularly embedded) 
>have it installed and for most them there's only "lzma-utils" in the 
>distribution package repositories which I understand is not compatible.
>
>I would basically need to download the source by hand and install
>it like back in the bad old "unix with all useful commands missing"
>HP-UX/Solaris/etc. days.

When was the last time you compiled a Linux kernel on HP-UX or Solaris?
I think others did that first (me being along the party), and quite
frankly, the plain Solaris without CSW has quickly-reachable limits
even for non-kernels.
