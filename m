Return-Path: <linux-kernel-owner+w=401wt.eu-S1755625AbZJFAKO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755625AbZJFAKO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 20:10:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755506AbZJFAKN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 20:10:13 -0400
Received: from outbound-mail-150.bluehost.com ([67.222.38.40]:55781 "HELO
	outbound-mail-150.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755278AbZJFAKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 20:10:12 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=ec6A3JImgVY9+CJTW1Ehpo4wK1XIHAtkK5z+TEEhNV5AqEK2LCkwUfh+Wqc67ScULOkrwxAGOqoQFsXRCXqTHuKRebfQeOJZp4+x3b0NINc5agzmWAYy2Te1VYNVJZKI;
Date: Mon, 5 Oct 2009 17:09:26 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: gabe@blackfam.net, gabebblack@gmail.com, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: TI PCIe-PCI bridge quirks
Message-ID: <20091005170926.7e34368c@jbarnes-g45>
In-Reply-To: <20090922220747.702c3b11@infradead.org>
References: <8a15eb2b0909221201k70b9e9darc6fda53f87bfae29@mail.gmail.com>
	<20090922211101.076e9763@infradead.org>
	<8a15eb2b0909221237s5d3e408do4e3bed8aaaa337a8@mail.gmail.com>
	<20090922220747.702c3b11@infradead.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Sep 2009 22:07:47 +0200
Arjan van de Ven <arjan@infradead.org> wrote:

> On Tue, 22 Sep 2009 14:37:16 -0500
> Gabe Black <gabebblack@gmail.com> wrote:
> 
> > On Tue, Sep 22, 2009 at 2:11 PM, Arjan van de Ven
> > <arjan@infradead.org> wrote:
> > >
> > > sounds like this is worth a PCI quirk in the kernel...
> > >
> > 
> > Is there documentation on how one would go about writing a "PCI
> > quirk"?
> > 
> 
> I would look at the existing quirks in the drivers/pci/quirks.c
> file... plenty of good (or bad, depending on how you look at it)
> examples...

Gabe, did you figure out how to do this?  Do you need any more help?

-- 
Jesse Barnes, Intel Open Source Technology Center
