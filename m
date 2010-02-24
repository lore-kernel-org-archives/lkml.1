Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436Ab0BXHM5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 02:12:57 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:56947 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755097Ab0BXHM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 02:12:56 -0500
Date: Tue, 23 Feb 2010 23:12:40 -0800 (PST)
From: Christian Kujau <lists@nerdbynature.de>
To: Johannes Buchner <buchner.johannes@gmx.at>
cc: Edward Shishkin <edward.shishkin@gmail.com>,
       Ronni Holm-Nielsen <theronni@gmail.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       ReiserFS Development List <reiserfs-devel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       xfs@oss.sgi.com, Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: Re: [patch 0/7] per-bdi flushing model improvements. reiser4
In-Reply-To: <20100222084753.0a5d613c.buchner.johannes@gmx.at>
Message-ID: <alpine.DEB.2.01.1002232307380.28195@bogon.housecafe.de>
References: <201002020255.46920.edward.shishkin@gmail.com> <20100202081728.GA2384@infradead.org> <4B6843E9.9070600@gmail.com> <20100202194208.GD5733@kernel.dk> <5e2ec5ac1002021345g569c743dtc5ccf77cde6738ae@mail.gmail.com> <4B68A68C.6030001@gmail.com>
 <20100222084753.0a5d613c.buchner.johannes@gmx.at>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX1+eAgy56R7OxOgd4MeQ6vxeXV00fmmWo+wELGD
 j8hWreUcnyMuuoe2Jrd+oSNb6Epza+ewvOCp3gqf0Dw0kA9vVI
 PJXeAB6svDEqxCTEsTVlQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Feb 2010 at 08:47, Johannes Buchner wrote:
> It'd be great if someone could solve this, as the reiser4 patch is
> not usable in its current state, with or without my illfated attempts
> to fix it.

FWIW, I'm running Linus' latest -git with refs/heads/reiser4 on top[0], no 
issues during 2.6.33-git so far. Try it, if you don't like 
manually applying patches either :-)

Christian.

[0] http://git.zen-kernel.org/?p=kernel/zen.git;a=shortlog;h=refs/heads/reiser4
-- 
BOFH excuse #275:

Bit rot
