Return-Path: <linux-kernel-owner+w=401wt.eu-S1758411AbYLLDT6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758411AbYLLDT6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 22:19:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757693AbYLLDTt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 22:19:49 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60363
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757460AbYLLDTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 22:19:48 -0500
Date: Thu, 11 Dec 2008 19:19:49 -0800 (PST)
Message-Id: <20081211.191949.05090709.davem@davemloft.net>
To: dhowells@redhat.com
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.28-rc8
From: David Miller <davem@davemloft.net>
In-Reply-To: <24401.1229009346@redhat.com>
References: <alpine.LFD.2.00.0812101651130.3340@localhost.localdomain>
	<24401.1229009346@redhat.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>
Date: Thu, 11 Dec 2008 15:29:06 +0000

> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> >  (a) just make the -rc's go on a few more weeks, and do 2.6.28 after xmas
> > 
> >      I like this, because alledgely people are debugging things, and we'd 
> >      get a more stable 2.6.28.
> 
> Which would perhaps mean that the merge window is open during LCA, which will
> be inconvenient for some people.  On the other hand, it might put the culprits
> where you can lay your hands on them.

That happened in Melbourne and it wasn't pleasant.  Instead
of enjoying talks at the conference some of us were stressing
out on our laptops dealing with our merges instead.
