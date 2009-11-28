Return-Path: <linux-kernel-owner+w=401wt.eu-S1754056AbZK1Mnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056AbZK1Mnr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Nov 2009 07:43:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754007AbZK1Mnq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Nov 2009 07:43:46 -0500
Received: from lazybastard.de ([212.112.238.170]:48157 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753984AbZK1Mnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Nov 2009 07:43:46 -0500
Date: Sat, 28 Nov 2009 13:43:36 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for November 27 (logfs: hash_index)
Message-ID: <20091128124336.GA19205@logfs.org>
References: <20091127181915.a6af7ba3.sfr@canb.auug.org.au> <4B10A04A.7090703@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4B10A04A.7090703@oracle.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 November 2009 20:00:10 -0800, Randy Dunlap wrote:
> Stephen Rothwell wrote:
> > Hi all,
> > 
> > Changes since 20091126:
> 
> 
> on i386 (X86_32):
> 
> fs/built-in.o: In function `hash_index':
> dir.c:(.text+0x6c1f2): undefined reference to `__umoddi3'

Oops!  Fixed now.

Jörn

-- 
Linux is more the core point of a concept that surrounds "open source"
which, in turn, is based on a false concept. This concept is that
people actually want to look at source code.
-- Rob Enderle
