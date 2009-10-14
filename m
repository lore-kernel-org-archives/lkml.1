Return-Path: <linux-kernel-owner+w=401wt.eu-S934804AbZJNP4O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934804AbZJNP4O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 11:56:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934790AbZJNP4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 11:56:13 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:45657 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934749AbZJNP4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 11:56:11 -0400
Date: Wed, 14 Oct 2009 08:55:15 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for October 14
Message-Id: <20091014085515.f40067c1.randy.dunlap@oracle.com>
In-Reply-To: <20091014163445.f0441473.sfr@canb.auug.org.au>
References: <20091014163445.f0441473.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4AD5F46F.00FD:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Oct 2009 16:34:45 +1100 Stephen Rothwell wrote:

> Changes since 20091013:
> 
> Undropped tree: i7core_edac
> 
> My fixes tree contains a build fix for powerpc/kvm.
> 
> The pci tree gained a conflict against Linus' tree.
> 
> The kbuild tree gained a build failure that required me to remove
> include/asm/asm-offsets.h from my object tree.
> 
> The net tree lost its build failure.
> 
> The percpu tree lost its build failure.
> 
> The tty tree still had a build failure for which I reverted a commit.
> 
> ----------------------------------------------------------------------------
> 
> I have created today's linux-next tree at
> git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
> (patches at http://www.kernel.org/pub/linux/kernel/v2.6/next/ ).  If you
> are tracking the linux-next tree using git, you should not use "git pull"
> to do so as that will try to merge the new linux-next release with the
> old one.  You should use "git fetch" as mentioned in the FAQ on the wiki
> (see below).

Hi Stephen,

Where are today's .bz2 file and the .sign files?

and when did pub/kernel/people/sfr/linux-next/ disappear?

The kernel.org/kdist/finger_banner file now reports:
The latest linux-next version of the Linux kernel is:         next-20091013

instead of 20091014.

---
~Randy
