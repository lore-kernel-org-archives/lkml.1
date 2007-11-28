Return-Path: <linux-kernel-owner+w=401wt.eu-S1759477AbXK1VxK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759477AbXK1VxK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 16:53:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755672AbXK1Vw5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 16:52:57 -0500
Received: from mg.nix.la ([75.126.232.227]:59209 "EHLO mg.nix.la"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755166AbXK1Vw5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 16:52:57 -0500
X-Greylist: delayed 1822 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Nov 2007 16:52:57 EST
From: Anton Petrusevich <casus@casus.us>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] mm/page-writeback - highmem_is_dirtyable option (replacesdirty_highmem patch)
Date: Wed, 28 Nov 2007 22:22:29 +0100
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711282222.30004.casus@casus.us>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Well, it was quick enough to just do - here's the patch. I've
> also updated the documentation a bit to clarify the intention and
>  the reasons why you might want to use it (based in part on the 
>  comments to the original change that made highmem uncountable for
>  dirtyness purposes)
 
>  Tested and applied against 2.6.23.9 (our build script makes Debian
>  packages from a clean unpack of kernel major plus patch minor plus
>  svn checkout of out quilt series and apply regardless, so it was
>  just as easy to bump the version number while I was at it).
 
>  Builds, boots, passes a quick run of the test program I used last
>  time around.
 
>  Bron.
 
Thanks Bron! I can use vmware again!
-- 
Anton Petrusevich
