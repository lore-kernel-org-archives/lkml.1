Return-Path: <linux-kernel-owner+w=401wt.eu-S937779AbXG3QpO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937779AbXG3QpO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 12:45:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760353AbXG3QpA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 12:45:00 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:37293
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759242AbXG3Qo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 12:44:59 -0400
Date: Mon, 30 Jul 2007 09:43:44 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Andre Noll <maan@systemlinux.org>,
       Wim Van Sebroeck <wim@iguana.be>, Borislav Petkov <bbpetkov@yahoo.de>,
       Bret Towe <magnade@gmail.com>, Nick Piggin <npiggin@suse.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Jakub Jelinek <jakub@redhat.com>,
       Eric Sesterhenn <snakebyte@gmx.de>, Sid Boyce <g3vbv@blueyonder.co.uk>
Subject: Re: [1/3] 2.6.23-rc1: known regressions v3
In-Reply-To: <46AE12EE.1070501@googlemail.com>
Message-ID: <Pine.LNX.4.64.0707300942460.11330@asgard.lang.hm>
References: <46AE12EE.1070501@googlemail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jul 2007, Michal Piotrowski wrote:

> Subject         : /usr/bin/ld: section .text [ffffffffff700500 -> ffffffffff7007e3] overlaps section .gnu.version_d [ffffffffff7004d8 -> ffffffffff70050f]
> References      : http://lkml.org/lkml/2007/7/22/239
> Last known good : ?
> Submitter       : Andre Noll <maan@systemlinux.org>
> Caused-By       : ?
> Handled-By      : Andi Kleen <ak@suse.de>
>                  Jakub Jelinek <jakub@redhat.com>
> Status          : problem is being debugged

I'm seeing this on 2.6.22.1 as well. the resulting kernel has seemed to 
work for me so I was ignoreing it.

David Lang
