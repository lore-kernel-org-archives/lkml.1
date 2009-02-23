Return-Path: <linux-kernel-owner+w=401wt.eu-S1755457AbZBWOjg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457AbZBWOjg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 09:39:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753960AbZBWOj0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 09:39:26 -0500
Received: from vsmtp04.dti.ne.jp ([202.216.231.139]:49791 "EHLO
	vsmtp04.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523AbZBWOjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 09:39:25 -0500
From: hooanon05@yahoo.co.jp
Subject: Re: [RFC 7/8] Aufs2: mmap 
To: Tomas M <tomas@slax.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <49A269F7.3040602@slax.org>
References: <7558.1235374266@jrobl> <7828.1235374676@jrobl> <49A269F7.3040602@slax.org>
Date: Mon, 23 Feb 2009 23:39:21 +0900
Message-ID: <14258.1235399961@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Tomas M:
> > In Unionfs, it took an approach which the memory pages mapped to
> > filedata are copied from the lower (real) file into the Unionfs's
> > virtual one and handles it by address_space operations. Recently Unionfs
> > changed it to this approach which aufs adopted since Jul 2006.
> 
> I think there are much more areas where people around unionfs actually get the good ideas from AUFS. But it appears most projects already switched from StonyBrook's unionfs to AUFS, since AUFS proves to be better for many years.

Yes, AUFS is used by many people for many years.
And several people asked me to put it into mainline. Unfortunately I am
not the one who decide it. I can only post and ask to do it.


J. R. Okajima
