Return-Path: <linux-kernel-owner+w=401wt.eu-S1756369AbYHVRoO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756369AbYHVRoO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 13:44:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754323AbYHVRnz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 13:43:55 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:3332 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754258AbYHVRny (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 13:43:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=A5UuJvCTXNyVDbIJfHwaEEFfRbUF/r7y61klC8rCQJlzy7LMSQ0zzCujcTYXSAyUlk
         rZA962MzI9oomkKsRi++wT8Bt5UaQTAESTeu+9+aKgYicBiHBSWvYtAatto0GeRWmRtw
         BJ7FXVdhDBA16xEwLFexsOgTlyEGHUoEYh5WQ=
Message-ID: <6934efce0808221043i3d463ac2gb54b7dd4cfde4b81@mail.gmail.com>
Date: Fri, 22 Aug 2008 10:43:52 -0700
From: "Jared Hulbert" <jaredeh@gmail.com>
To: "Arnd Bergmann" <arnd@arndb.de>
Subject: Re: [PATCH 06/10] AXFS: axfs_super.c
Cc: "Phillip Lougher" <phillip@lougher.demon.co.uk>,
       Linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>,
       "=?UTF-8?Q?J=C3=B6rn_Engel?=" <joern@logfs.org>, tim.bird@am.sony.com,
       cotte@de.ibm.com, nickpiggin@yahoo.com.au
In-Reply-To: <200808221852.38950.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48AD0101.4020505@gmail.com> <48AE19AD.1020209@lougher.demon.co.uk>
	 <6934efce0808212005h30fa16d8w48833e8a0becfd8c@mail.gmail.com>
	 <200808221852.38950.arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It certainly sounds like something for your medium-term TODO list,
> although I wouldn't think of it as a show-stopper.

Maybe.  It more of a feature rather than a bug.  It makes stat() and
such fast.  The trade off is RAM...
