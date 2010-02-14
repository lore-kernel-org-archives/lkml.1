Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758314Ab0BNJ4N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 04:56:13 -0500
Received: from one.firstfloor.org ([213.235.205.2]:39886 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081Ab0BNJ4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 04:56:12 -0500
Date: Sun, 14 Feb 2010 10:56:07 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Phillip Lougher <phillip@lougher.demon.co.uk>
Cc: Jean Delvare <khali@linux-fr.org>, lasse.collin@tukaani.org,
       linux-kernel <linux-kernel@vger.kernel.org>, mirrors@kernel.org,
       users@kernel.org, "FTPAdmin Kernel.org" <ftpadmin@kernel.org>,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: [kernel.org users] XZ Migration discussion
Message-ID: <20100214095607.GB21783@one.firstfloor.org>
References: <4B744E13.8040004@kernel.org> <20100211205129.GA26105@elf.ucw.cz> <20100213181008.479509f5@hyperion.delvare> <4B773B31.1020802@lougher.demon.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B773B31.1020802@lougher.demon.co.uk>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> With xz you have just one C/C++ implementation with a single library with
> an undocumented API for C/C++ programmers.

... which is not even widely deployed. I did a quick survey and none of 
my systems (none of which terrible old and not particularly embedded) 
have it installed and for most them there's only "lzma-utils" in the 
distribution package repositories which I understand is not compatible.

I would basically need to download the source by hand and install
it like back in the bad old "unix with all useful commands missing"
HP-UX/Solaris/etc. days.

Please keep .gz and better .bz2

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
