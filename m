Return-Path: <linux-kernel-owner+w=401wt.eu-S1753792AbYEaHrp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792AbYEaHrp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 03:47:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751473AbYEaHrh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 03:47:37 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50376
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751381AbYEaHrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 03:47:36 -0400
Date: Sat, 31 May 2008 00:47:32 -0700 (PDT)
Message-Id: <20080531.004732.193727163.davem@davemloft.net>
To: drepper@redhat.com
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, mtk.manpages@gmail.com
Subject: Re: [PATCH 3/3] 64-bit futexes: x86 support
From: David Miller <davem@davemloft.net>
In-Reply-To: <4840D807.2030406@redhat.com>
References: <4840D335.6040406@redhat.com>
	<alpine.LFD.1.10.0805302129240.3141@woody.linux-foundation.org>
	<4840D807.2030406@redhat.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ulrich Drepper <drepper@redhat.com>
Date: Fri, 30 May 2008 21:45:59 -0700

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Linus Torvalds wrote:
> > You just blindly 
> > claim that you're the only one who can know things like this and can do 
> > serialization, and that your way is the only approach.
> 
> Nonsense.

No, Ulrich.  Eveyone who ever tries to work with you, and
comes away frustrated, has this exact impression.

Whether it's intentional or not, that doesn't matter, people
perceive you as an arrogant know it all who is extremely
difficult to work with.  And you can be sure that projects
that you are the primary maintainer of, such as GLIBC, suffer
because of it.
