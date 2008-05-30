Return-Path: <linux-kernel-owner+w=401wt.eu-S1755693AbYE3USk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755693AbYE3USk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 16:18:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753153AbYE3US1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 16:18:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39056 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753860AbYE3US0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 16:18:26 -0400
Date: Fri, 30 May 2008 13:17:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Michael Kerrisk" <mtk.manpages@googlemail.com>
Cc: miklos@szeredi.hu, drepper@redhat.com, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org, linux-man@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] utimensat() non-conformances and fixes [v3]
Message-Id: <20080530131722.07f9723b.akpm@linux-foundation.org>
In-Reply-To: <cfd18e0f0805301124o5f217dden10726b268d05d81a@mail.gmail.com>
References: <482D4665.4050401@gmail.com>
	<E1Jx3Gw-0002eA-55@pomaz-ex.szeredi.hu>
	<48401E7E.9090304@gmail.com>
	<E1K27bZ-0002Gk-3b@pomaz-ex.szeredi.hu>
	<cfd18e0f0805301124o5f217dden10726b268d05d81a@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 May 2008 20:24:22 +0200
"Michael Kerrisk" <mtk.manpages@googlemail.com> wrote:

> > After we fixed the original issue, we can still think about this other
> > thing :)
> 
> Okay, by now quite a bit of my time has been wasted, and my patience
> is starting to get a little thin.

Well yeah.  This has been dragging on for ages.  I was going to just
apply this patch and stomp off again but this:

  "against 2.6.26rc2, with the 2008-05-19 git changes you sent me
   applied"

stymied me.

Please, if poss, just send a standalone, fully-changelogged,
not-referential-to-some-random-email-discussion patch and let's get
going.

(Where's Ulrich, btw?)
