Return-Path: <linux-kernel-owner+w=401wt.eu-S1762291AbXGJUkn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762291AbXGJUkn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 16:40:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756788AbXGJUke
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 16:40:34 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60493 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757125AbXGJUkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 16:40:33 -0400
Date: Tue, 10 Jul 2007 13:35:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: ata and netdev (was Re: -mm merge plans for 2.6.23)
Message-Id: <20070710133519.739ad282.akpm@linux-foundation.org>
In-Reply-To: <4693EC9B.6020305@ru.mvista.com>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
	<4693C4F8.40903@garzik.org>
	<20070710112458.e9dbb55e.akpm@linux-foundation.org>
	<4693EC9B.6020305@ru.mvista.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jul 2007 00:31:23 +0400
Sergei Shtylyov <sshtylyov@ru.mvista.com> wrote:

> Hello.
> 
> Andrew Morton wrote:
> 
> > 3x59x-fix-pci-resource-management.patch: you wrote it ;) I have a comment
> 
>     No, I did, almost a year ago already. :-)

I thought that was odd.  I fixed the attribution.
 
> > here:
> 
> > - I don't remember the story with cardbus either.  Presumably once upon a
> >   time the cardbus layer was claiming IO regions on behalf of cardbus
> >   devices (?)
> 
>     IIRC, that's your own comment.

yup, that's what "I have a comment" meant ;)

The comment seems rather bogus actually.  Let's just merge it.

