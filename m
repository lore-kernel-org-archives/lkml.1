Return-Path: <linux-kernel-owner+w=401wt.eu-S1760671AbZDCAYv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760671AbZDCAYv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 20:24:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755679AbZDCAYm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 20:24:42 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:56947
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbZDCAYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 20:24:41 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Subject: Re: make headers_install broken for ARCH=m68k in 2.6.29-rc7.
Date: Thu, 2 Apr 2009 19:24:35 -0500
User-Agent: KMail/1.9.10
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org, dwmw2@infradead.org
References: <200903120437.03837.rob@landley.net> <200904012114.07183.rob@landley.net> <20090402215926.GD3795@csclub.uwaterloo.ca>
In-Reply-To: <20090402215926.GD3795@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904021924.36815.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 02 April 2009 16:59:26 Lennart Sorensen wrote:
> On Wed, Apr 01, 2009 at 09:14:05PM -0500, Rob Landley wrote:
> > uClibc's working for me just fine.  Either grab the most recent build
> > scripts from http://impactlinux.com/hg/firmware or grab the prebuilt
> > binaries from http://impactlinux.com/fwl/downloads/snapshots/ (which has
> > cross compilers, root filesystem tarballs, and system images bootable by
> > qemu).
> >
> > I haven't tested m68k yet because qemu doesn't support it (just
> > coldfire), and aranym hasn't got a serial console, but it did compile
> > using the same build scripts as all the other targets...
>
> Well my uclibc issues using 0.9.30.1 are:
>
> When using msh from busybox compiled with gcc 4.3.3 for m68k-uclinux with

Here I'm using bash 2.05b, using gcc 4.2.1 (last gplv2 release), building the 
with-mmu target, and I haven't actually got a test environment to boot the 
result in working yet, so yeah.

Rob
-- 
GPLv3 is to GPLv2 what Attack of the Clones is to The Empire Strikes Back.
