Return-Path: <linux-kernel-owner+w=401wt.eu-S1423218AbXBHQec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423218AbXBHQec (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 11:34:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423220AbXBHQeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 11:34:31 -0500
Received: from scrub.xs4all.nl ([194.109.195.176]:34449 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423218AbXBHQea (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 11:34:30 -0500
Date: Thu, 8 Feb 2007 17:34:05 +0100 (CET)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Oleg Verych <olecom@flower.upol.cz>,
       Alexey Dobriyan <adobriyan@gmail.com>, sam@ravnborg.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kai Germaschewski <kai@germaschewski.name>
Subject: Re: [patch, fix build regression] kbuild: Kbuild.include avoid using
 spaces in call arguments
In-Reply-To: <20070207203047.51a95ad0.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0702081724580.14457@scrub.home>
References: <20070207165204.GA5537@martell.zuzino.mipt.ru>
 <Pine.LNX.4.64.0702071846180.14457@scrub.home> <20070207220435.GC22699@flower.upol.cz>
 <Pine.LNX.4.64.0702080029030.14457@scrub.home>
 <Pine.LNX.4.64.0702071546420.8424@woody.linux-foundation.org>
 <20070207203047.51a95ad0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 7 Feb 2007, Andrew Morton wrote:

> I'm sitting on these:
> 
> search-a-little-harder-for-mkimage.patch
> make-mkcompile_h-use-lang=c-and-lc_all=c-for-cc-v.patch
> add-mailmap-for-proper-git-shortlog-output.patch
> qconf-immediately-update-integer-and-string-values-in-xconfig-display-take-2.patch
> qconf-relocate-search-command.patch
> qconf-fix-showing-help-info-on-failed-search.patch
> qconf-back-button-behaviour-normalization.patch
> kbuild-remove-references-to-deprecated-prepare-all-target.patch
> new-toplevel-target-headers_check_all.patch
> 
> But I'm not sure that anyone has reviewed them much.

Patches look fine and most of the kconfig related patches are already the 
result of a review.

bye, Roman
