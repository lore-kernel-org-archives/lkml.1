Return-Path: <linux-kernel-owner+w=401wt.eu-S1753934AbYG3PmK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934AbYG3PmK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 11:42:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754868AbYG3Plr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 11:41:47 -0400
Received: from outbound-mail-155.bluehost.com ([67.222.39.35]:58004 "HELO
	outbound-mail-155.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754490AbYG3Plq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 11:41:46 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=T8kmXM1q77FjdZ6CF7EsH04pZb9eT8Oqj9d2By8TezwpF/GLLII5VWzG4d+BSzQRRf1aRVQMshJuLEyCvyirHd/YCAGDCOSDi/FIzOWNeQYC5iW7xS4+S/U1MXepshOd;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [patch 00/31] pci_ids.h, kernel 2.6.27-rc1, sort DEVICE_IDs within VENDOR_IDs
Date: Wed, 30 Jul 2008 08:41:38 -0700
User-Agent: KMail/1.9.9
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>, mcs6502@gmail.com,
       linux-kernel@vger.kernel.org
References: <E1KO7OU-0007BT-Ff@wraith.cs.uow.edu.au> <200807300723.14970.jbarnes@virtuousgeek.org> <20080730081047.067fd676@infradead.org>
In-Reply-To: <20080730081047.067fd676@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807300841.39053.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, July 30, 2008 8:10 am Arjan van de Ven wrote:
> On Wed, 30 Jul 2008 07:23:14 -0700
>
> Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> > On Wednesday, July 30, 2008 3:35 am Alan Cox wrote:
> > > > a) slam it into mainline immediately or
> > > >
> > > > b) ask you to regenerate it during the 2.6.28 merge window or
> > > >
> > > > c) forget the whole idea.
> > >
> > > I vote for (a). At some point it needs doing and the sooner we do
> > > it the better. I've scanned all the diffs and they appear correct.
> > > As we've seen from the MAINTAINERS file once you get errors they
> > > spread rapidly.
> > >
> > > Acked-by: Alan Cox <alan@redhat.com>
> >
> > Yeah, let's just get it over with.
>
> if this was done by a script.. can we just get that script so that you
> as PCI maintainer can run that on a very regular basis?

Sure, though I'll also try to be vigilant about future additions.

Jesse
