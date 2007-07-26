Return-Path: <linux-kernel-owner+w=401wt.eu-S936142AbXGZV0O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936142AbXGZV0O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 17:26:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758159AbXGZV0A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 17:26:00 -0400
Received: from mail-04.jhb.wbs.co.za ([196.2.97.3]:13466 "EHLO
	mail-04.jhb.wbs.co.za" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753279AbXGZVZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 17:25:59 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CAD+uqEbEHh/D/2dsb2JhbAA
From: Bongani Hlope <bhlope@mweb.co.za>
To: Rene Herman <rene.herman@gmail.com>
Subject: Re: updatedb
Date: Thu, 26 Jul 2007 23:25:39 +0200
User-Agent: KMail/1.9.7
Cc: Robert Deaton <false.hopes@gmail.com>, linux-kernel@vger.kernel.org,
       ck list <ck@vds.kolivas.org>, linux-mm@kvack.org
References: <367a23780707250830i20a04a60n690e8da5630d39a9@mail.gmail.com> <200707260908.02781.bhlope@mweb.co.za> <46A854C7.4060908@gmail.com>
In-Reply-To: <46A854C7.4060908@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707262325.39862.bhlope@mweb.co.za>
X-Original-Subject: Re: updatedb
X-Scan-Signature: 19fcc4e33071de569e84e0c85c227ce4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 July 2007 10:01:11 Rene Herman wrote:
> On 07/26/2007 09:08 AM, Bongani Hlope wrote:
> > On Thursday 26 July 2007 08:56:59 Rene Herman wrote:
> >> Great. Now concentrate on the "swpd" column, as it's the only thing
> >> relevant here. The fact that an updatedb run fills/replaces caches is
> >> completely and utterly unsurprising and not something swap-prefetch
> >> helps with. The only thing it does is bring back stuff from _swap_.
> >
> > ;)
> >
> > I have 2Gb of RAM and I never ever touched swap on all my work loads. I
> > was just showing the behavior of updatedb on my desktop. I have never
> > even looked at the swap-prefetch patch (for obvious reasons).
>
> I see... thanks for the report :)
>
> > I think people should also look at their /proc/sys/vm/overcommit_ratio
>
> In the sense that current stuff might be evicted earlier with no or little
> overcommit?
>

Oops, that was suppose to be /proc/sys/vm/swappiness Sorry about the 
confusion.
