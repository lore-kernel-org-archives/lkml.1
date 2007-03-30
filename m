Return-Path: <linux-kernel-owner+w=401wt.eu-S1945929AbXC3D4c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945929AbXC3D4c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 23:56:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945932AbXC3D4c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 23:56:32 -0400
Received: from koto.vergenet.net ([210.128.90.7]:60310 "EHLO koto.vergenet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945929AbXC3D4b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 23:56:31 -0400
Date: Fri, 30 Mar 2007 11:34:10 +0900
From: Simon Horman <horms@verge.net.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Vivek Goyal <vgoyal@in.ibm.com>, fastboot@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kdump/kexec: calculate note size at compile time
Message-ID: <20070330023408.GA8726@verge.net.au>
References: <20070328061855.GA9576@verge.net.au> <20070328064353.GD4941@in.ibm.com> <20070328071315.GC29303@verge.net.au> <20070328080853.GE4941@in.ibm.com> <20070329033056.GD22141@verge.net.au> <20070329174145.0db7779f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070329174145.0db7779f.akpm@linux-foundation.org>
User-Agent: mutt-ng/devel-r804 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2007 at 05:41:45PM -0700, Andrew Morton wrote:
> On Thu, 29 Mar 2007 12:30:59 +0900
> Simon Horman <horms@verge.net.au> wrote:
> 
> > [PATCH] kdump/kexec: calculate note size at compile time
> 
> i386 allmodconfig, gcc-4.1.0:
> 
> In file included from init/initramfs.c:508:
> include/linux/kexec.h:148: error: variable-size type declared outside of any function

Thanks, I will look into this.

-- 
Horms
  H: http://www.vergenet.net/~horms/
  W: http://www.valinux.co.jp/en/

