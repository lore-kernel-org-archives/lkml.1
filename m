Return-Path: <linux-kernel-owner+w=401wt.eu-S1754503AbZBWJSo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754503AbZBWJSo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 04:18:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754095AbZBWJSb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 04:18:31 -0500
Received: from cuda1.bluetone.cz ([212.158.128.5]:44392 "EHLO mail.bluetone.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753704AbZBWJSa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 04:18:30 -0500
X-Greylist: delayed 319 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Feb 2009 04:18:30 EST
Message-ID: <49A269F7.3040602@slax.org>
Date: Mon, 23 Feb 2009 10:18:47 +0100
From: Tomas M <tomas@slax.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081209)
MIME-Version: 1.0
To: hooanon05@yahoo.co.jp
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 7/8] Aufs2: mmap
References: <7558.1235374266@jrobl> <7828.1235374676@jrobl>
In-Reply-To: <7828.1235374676@jrobl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> In Unionfs, it took an approach which the memory pages mapped to
> filedata are copied from the lower (real) file into the Unionfs's
> virtual one and handles it by address_space operations. Recently Unionfs
> changed it to this approach which aufs adopted since Jul 2006.

I think there are much more areas where people around unionfs actually get the good ideas from AUFS. But it appears most projects already switched from StonyBrook's unionfs to AUFS, since AUFS proves to be better for many years.


Tomas M
slax.org
