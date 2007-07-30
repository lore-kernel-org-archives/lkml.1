Return-Path: <linux-kernel-owner+w=401wt.eu-S937364AbXG3Rse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937364AbXG3Rse (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 13:48:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760821AbXG3RsZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 13:48:25 -0400
Received: from rv-out-0910.google.com ([209.85.198.188]:26362 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760607AbXG3RsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 13:48:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=HUR8ablyi5rAz/WNG1YIjADNgTaZTldpOT2MOiasynJZRF2vl4XJSVlSFReGoz9N9K7zXJLgAtsie/KjXpuKooHGx7RoXVSjc4uyTh4F85qpNeuQwArJjxNtx/zfjCq3ZoGSEW5hGmO6pwFlAB0eD1+IqJESn37sU1jT56jcgwE=
Message-ID: <6bffcb0e0707301048k6aaa9e40ve9f319f3d999713b@mail.gmail.com>
Date: Mon, 30 Jul 2007 19:48:23 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "david@lang.hm" <david@lang.hm>
Subject: Re: [1/3] 2.6.23-rc1: known regressions v3
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Andre Noll" <maan@systemlinux.org>, "Wim Van Sebroeck" <wim@iguana.be>,
       "Borislav Petkov" <bbpetkov@yahoo.de>, "Bret Towe" <magnade@gmail.com>,
       "Nick Piggin" <npiggin@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "Jakub Jelinek" <jakub@redhat.com>,
       "Eric Sesterhenn" <snakebyte@gmx.de>,
       "Sid Boyce" <g3vbv@blueyonder.co.uk>
In-Reply-To: <Pine.LNX.4.64.0707300942460.11330@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46AE12EE.1070501@googlemail.com>
	 <Pine.LNX.4.64.0707300942460.11330@asgard.lang.hm>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/07/07, david@lang.hm <david@lang.hm> wrote:
> On Mon, 30 Jul 2007, Michal Piotrowski wrote:
>
> > Subject         : /usr/bin/ld: section .text [ffffffffff700500 -> ffffffffff7007e3] overlaps section .gnu.version_d [ffffffffff7004d8 -> ffffffffff70050f]
> > References      : http://lkml.org/lkml/2007/7/22/239
> > Last known good : ?
> > Submitter       : Andre Noll <maan@systemlinux.org>
> > Caused-By       : ?
> > Handled-By      : Andi Kleen <ak@suse.de>
> >                  Jakub Jelinek <jakub@redhat.com>
> > Status          : problem is being debugged
>
> I'm seeing this on 2.6.22.1 as well.

Ok, so it is not a regression.

> the resulting kernel has seemed to
> work for me so I was ignoreing it.
>
> David Lang
>

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
