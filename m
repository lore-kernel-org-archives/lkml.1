Return-Path: <linux-kernel-owner+w=401wt.eu-S935359AbXG0Hyt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935359AbXG0Hyt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 03:54:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763161AbXG0HyX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 03:54:23 -0400
Received: from mail.gmx.net ([213.165.64.20]:45857 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1761966AbXG0HyU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 03:54:20 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/kSDA+EWzkmKp2n9YDz4dcQQtsX7obp6Go0BB3NU
	owBFItw5t8pRK3
Subject: Re: updatedb
From: Mike Galbraith <efault@gmx.de>
To: Rene Herman <rene.herman@gmail.com>
Cc: Jesper Juhl <jesper.juhl@gmail.com>, Andika Triwidada <andika@gmail.com>,
       Robert Deaton <false.hopes@gmail.com>, linux-kernel@vger.kernel.org,
       ck list <ck@vds.kolivas.org>, linux-mm@kvack.org
In-Reply-To: <46A98A14.3040300@gmail.com>
References: <367a23780707250830i20a04a60n690e8da5630d39a9@mail.gmail.com>
	 <46A773EA.5030103@gmail.com>
	 <a491f91d0707251015x75404d9fld7b3382f69112028@mail.gmail.com>
	 <46A81C39.4050009@gmail.com>
	 <7e0bae390707252323k2552c701x5673c55ff2cf119e@mail.gmail.com>
	 <9a8748490707261746p638e4a98p3cdb7d9912af068a@mail.gmail.com>
	 <46A98A14.3040300@gmail.com>
Content-Type: text/plain
Date: Fri, 27 Jul 2007 09:54:04 +0200
Message-Id: <1185522844.6295.64.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-07-27 at 08:00 +0200, Rene Herman wrote:

> The remaining issue of updatedb unnecessarily blowing away VFS caches is 
> being discussed (*) in a few thread-branches still running.

If you solve that, the swap thing dies too, they're one and the same
problem.

	-Mike

