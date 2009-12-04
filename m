Return-Path: <linux-kernel-owner+w=401wt.eu-S1757603AbZLEAAJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757603AbZLEAAJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 19:00:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932380AbZLEAAI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 19:00:08 -0500
Received: from outbound-mail-304.bluehost.com ([67.222.53.250]:55200 "HELO
	outbound-mail-304.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757413AbZLEAAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 19:00:07 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=itl1FuVuWuiBNnuLrwWUfCwClINUbV8Vy69zuDGGIcY9MxwDjpZA2/ag2CZhQoemNCLBe9f9UWjqfd5/Hb15jQULcwT926alR24Ue+TGy7glzTsh3OTWCLRg3oCq5kKk;
Date: Fri, 4 Dec 2009 15:59:22 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Matthew Wilcox <matthew@wil.cx>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: pci_find_parent_resource patch
Message-ID: <20091204155922.4e8b76b1@jbarnes-piketon>
In-Reply-To: <0AC7ED80-C475-4635-8EFA-6BB18B90D994@kernel.org>
References: <0AC7ED80-C475-4635-8EFA-6BB18B90D994@kernel.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Nov 2009 16:22:20 -0800
Yinghai Lu <yinghai@kernel.org> wrote:

> Jesse Barnes wrote:
> > I don't remember seeing it, is it for 2.6.32?
> I
> http://lkml.org/lkml/2009/8/7/352
> 
> not sure. better to make it in pci-next for a while.
> 
> in my local tree for a while

Wow, that's an old one.  Linus said a few times he didn't want that one
to go upstream though.

Linus?  You mentioned something about re-working it a bit...

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
