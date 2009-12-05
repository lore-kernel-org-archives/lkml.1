Return-Path: <linux-kernel-owner+w=401wt.eu-S932727AbZLEAbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932727AbZLEAbm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 19:31:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932656AbZLEAbj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 19:31:39 -0500
Received: from outbound-mail-139.bluehost.com ([67.222.39.29]:60058 "HELO
	outbound-mail-139.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932649AbZLEAbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 19:31:38 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=jx/tluUrrPB/w2c8E1/yHubO/h2JIkoqIW7Ca7Cy3I9mhoXrEfLNCrC6PRySL+N8IbdbTjOunsq4iWZb26SlKB2A9iWkI7QsOHaYaEd8PCnBBYefayyB/bBllSqNKRee;
Date: Fri, 4 Dec 2009 16:30:58 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Yinghai Lu <yinghai@kernel.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Ingo Molnar <mingo@elte.hu>,
       Matthew Wilcox <matthew@wil.cx>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: pci_find_parent_resource patch
Message-ID: <20091204163058.1d8a3c71@jbarnes-piketon>
In-Reply-To: <alpine.LFD.2.00.0912041624310.24579@localhost.localdomain>
References: <0AC7ED80-C475-4635-8EFA-6BB18B90D994@kernel.org>
	<20091204155922.4e8b76b1@jbarnes-piketon>
	<alpine.LFD.2.00.0912041624310.24579@localhost.localdomain>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Dec 2009 16:24:58 -0800 (PST)
Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > On Tue, 24 Nov 2009 16:22:20 -0800
> > Yinghai Lu <yinghai@kernel.org> wrote:
> > 
> > > Jesse Barnes wrote:
> > > > I don't remember seeing it, is it for 2.6.32?
> > > I
> > > http://lkml.org/lkml/2009/8/7/352
> > > 
> > > not sure. better to make it in pci-next for a while.
> > > 
> > > in my local tree for a while
> > 
> > Wow, that's an old one.  Linus said a few times he didn't want that
> > one to go upstream though.
> > 
> > Linus?  You mentioned something about re-working it a bit...
> 
> Oh, no, I'm perfectly fine with it. I just think it needs testing.
> Merging it early in the merge window is fine.

Well I guess I didn't miss it and I knew we'd had this conversation
before.

I applied it back in early Nov but forgot to update my "todo"
mailbox. Anyway it'll go in with my first pull request.

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
