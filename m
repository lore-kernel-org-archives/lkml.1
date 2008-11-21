Return-Path: <linux-kernel-owner+w=401wt.eu-S1755604AbYKUMY1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755604AbYKUMY1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 07:24:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753620AbYKUMYS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 07:24:18 -0500
Received: from vsmtp04.dti.ne.jp ([202.216.231.139]:53961 "EHLO
	vsmtp04.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458AbYKUMYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 07:24:17 -0500
From: hooanon05@yahoo.co.jp
Subject: Re: [PATCH] loop file resizable 
To: Karel Zak <kzak@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, tomas@slax.org,
       linux-kernel@vger.kernel.org, akinobu.mita@gmail.com,
       util-linux-ng@vger.kernel.org
In-Reply-To: <20081121101209.GJ2961@nb.net.home>
References: <492120DC.1070407@slax.org> <20081118164207.137e92be.akpm@linux-foundation.org> <16149.1227066661@jrobl> <20081120132654.4c649eb0.akpm@linux-foundation.org> <20081121101209.GJ2961@nb.net.home>
Date: Fri, 21 Nov 2008 21:23:48 +0900
Message-ID: <7554.1227270228@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Karel Zak:
> > Presumably that would be some enhancement to losetup, or perhaps a new
> > tool.  Could the util-linux people please have a think about this and
> > comment?
> 
>  It shouldn't be a problem to extend the current losetup(8). I have no
>  problem with this change.

I have updated the userspace utility, logrow.c which I already posted
here.
Do you want me to post it here again?
If you tell me the URL of the base version of losetup, I will make a
patch.


J. R. Okajima
