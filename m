Return-Path: <linux-kernel-owner+w=401wt.eu-S1753309AbZJPSL3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309AbZJPSL3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 14:11:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752115AbZJPSL3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 14:11:29 -0400
Received: from mail-pz0-f188.google.com ([209.85.222.188]:65208 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832AbZJPSL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 14:11:28 -0400
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for October 16
References: <20091016170112.71ec36c7.sfr@canb.auug.org.au>
From: Kevin Hilman <khilman@deeprootsystems.com>
Organization: Deep Root Systems, LLC
Date: Fri, 16 Oct 2009 11:11:31 -0700
In-Reply-To: <20091016170112.71ec36c7.sfr@canb.auug.org.au> (Stephen Rothwell's message of "Fri\, 16 Oct 2009 17\:01\:12 +1100")
Message-ID: <87zl7rw6ng.fsf@deeprootsystems.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen,

I've changed the branch names slightly for the davinci tree (patch
below against todays next/master branch.)  Both branches will remain
for a few days, then I'll drop the old one.

Thanks,

Kevin



diff --git a/Next/Trees b/Next/Trees
index 0474f35..b644233 100644
--- a/Next/Trees
+++ b/Next/Trees
@@ -26,7 +26,7 @@ crypto-current	git	git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-
 ide-curent	git	git://git.kernel.org/pub/scm/linux/kernel/git/davem/ide-2.6.git#master
 dwmw2		git	git://git.infradead.org/users/dwmw2/random-2.6.git#master
 arm		git	ssh://master.kernel.org/home/rmk/linux-2.6-arm.git#devel
-davinci		git	git://git.kernel.org/pub/scm/linux/kernel/git/khilman/linux-davinci.git#for-next
+davinci		git	git://git.kernel.org/pub/scm/linux/kernel/git/khilman/linux-davinci.git#davinci-next
 pxa		git	git://git.kernel.org/pub/scm/linux/kernel/git/ycmiao/pxa-linux-2.6.git#for-next
 avr32		git	git://git.kernel.org/pub/scm/linux/kernel/git/hskinnemoen/avr32-2.6.git#avr32-arch
 blackfin	git	git://git.kernel.org/pub/scm/linux/kernel/git/vapier/blackfin.git#for-linus
