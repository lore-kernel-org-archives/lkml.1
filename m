Return-Path: <linux-kernel-owner+w=401wt.eu-S1755333AbYE3USQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333AbYE3USQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 16:18:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753226AbYE3UR5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 16:17:57 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:40220 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787AbYE3UR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 16:17:56 -0400
To: mtk.manpages@googlemail.com
CC: miklos@szeredi.hu, drepper@redhat.com, viro@zeniv.linux.org.uk,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-man@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-reply-to: <cfd18e0f0805301243h7d862963o8320a2c1f48942ce@mail.gmail.com>
	(mtk.manpages@googlemail.com)
Subject: Re: [PATCH] utimensat() non-conformances and fixes [v3]
References: <482D4665.4050401@gmail.com>
	 <E1Jx3Gw-0002eA-55@pomaz-ex.szeredi.hu> <48401E7E.9090304@gmail.com>
	 <E1K27bZ-0002Gk-3b@pomaz-ex.szeredi.hu>
	 <cfd18e0f0805301124o5f217dden10726b268d05d81a@mail.gmail.com> <cfd18e0f0805301243h7d862963o8320a2c1f48942ce@mail.gmail.com>
Message-Id: <E1K2B2k-0002kS-Cz@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 30 May 2008 22:17:42 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael,

> You omitted to answer my question, the last sentence below:

Oh, come on.  Where in my last mail did I say that these fixes
shouldn't be applied?  I was only objecting to putting a fix and an
independent cleanup (which by now I realized was not such a good idea)
into a single patch.

Miklos
