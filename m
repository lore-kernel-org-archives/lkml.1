Return-Path: <linux-kernel-owner+w=401wt.eu-S1757273AbZINVr5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757273AbZINVr5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 17:47:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755603AbZINVry
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 17:47:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51733 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755129AbZINVry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 17:47:54 -0400
Date: Mon, 14 Sep 2009 14:47:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: andi@firstfloor.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [0/5] kbuild: A couple of Kbuild fixes/improvements
Message-Id: <20090914144739.cd6ebf82.akpm@linux-foundation.org>
In-Reply-To: <20090914214347.GA7990@merkur.ravnborg.org>
References: <200909141018.915641783@firstfloor.org>
	<20090914214347.GA7990@merkur.ravnborg.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Sep 2009 23:43:47 +0200
Sam Ravnborg <sam@ravnborg.org> wrote:

> On Mon, Sep 14, 2009 at 10:18:05PM +0200, Andi Kleen wrote:
> > 
> > I sent those some time ago, but nobody seems to have merged them. Sam?
> 
> Then I should have them queued somewhere...
> Last months has been busy (again) so not much time for Linux stuff.
> Will find time to prepare some of my pending stuff for merge -
> hopefully before the weekend.
> 
> Thanks for the resend - let's see if andrew or I merge them first.
> 

Well, I'd prefer not to merge kbuild stuff as long as you're showing
signs of life.

I'll now hose these:

gitignore-usr-initramfs_datacpiobz2-and-usr-initramfs_datacpiolzma.patch
kernel-hacking-move-strip_asm_syms-from-general.patch
kbuild-add-static-to-prototypes.patch
ctags-usability-fix.patch
checkincludespl-close-file-as-soon-as-were-done-with-it.patch
checkincludespl-provide-usage-helper.patch
checkincludespl-add-option-to-remove-duplicates-in-place.patch
markup_oops-use-modinfo-to-avoid-confusion-with-underscored-module-names.patch
kbuild-generate-modulesbuiltin.patch
kbuild-rebuild-fix-for-makefilemodbuiltin.patch
kconfig-cross_compile-option.patch
kbuild-fix-cc1-options-check-to-ensure-we-do-not-use-fpic-when-compiling.patch
gconfig-disable-typeahead-find-search-in-treeviews.patch
kbuild-fix-ld-option-makefile-macro-to-really-work.patch
kbuild-check-if-linker-supports-the-x-option.patch
kbuild-echo-the-record_mcount-command.patch
kbuild-fail-build-if-recordmcountpl-fails.patch
kbuild-set-fconserve-stack-option-for-gcc-45.patch

at you :)
