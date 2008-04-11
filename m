Return-Path: <linux-kernel-owner+w=401wt.eu-S1753463AbYDKEYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463AbYDKEYc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 00:24:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750781AbYDKEYV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 00:24:21 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:60896 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbYDKEYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 00:24:21 -0400
Date: Fri, 11 Apr 2008 06:24:20 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: SL Baur <steve@xemacs.org>
cc: Benny Halevy <bhalevy@panasas.com>, Andy Whitcroft <apw@shadowen.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Richard Knutsson <ricknu-0@student.ltu.se>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [patch] checkpatch: relax spacing and line length
In-Reply-To: <ed10ee420804101652w467f4d1pc58da3736d7f54c7@mail.gmail.com>
Message-ID: <alpine.LNX.1.10.0804110623240.21182@fbirervta.pbzchgretzou.qr>
References: <alpine.LNX.1.10.0804060653020.30794@fbirervta.pbzchgretzou.qr>  <20080408171257.GF17915@shadowen.org> <47FCB458.3070403@panasas.com>  <20080409132548.GM17915@shadowen.org> <47FCF6AF.8010703@panasas.com>
 <ed10ee420804101652w467f4d1pc58da3736d7f54c7@mail.gmail.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Friday 2008-04-11 01:52, SL Baur wrote:
>On 4/9/08, Benny Halevy <bhalevy@panasas.com> wrote:
>
>>  In http://lkml.org/lkml/2008/2/26/533,
>>  SL Baur <steve <at> xemacs.org> said:
>>  > The proposed two space change is ugly.  Can someone NAK it?
>>
>>  I'm not sure what "two space change" proposal this Steve referred to
>>  and his rejection is based on not-to-sound aesthetic grounds.
>>
>>  The motivation behind our proposal is more than just aesthetic.
>>  I believe that using tabs for indent and then spaces for alignment
>>  is functionally better, works for everybody, and will eventually result
>>  in a more readable code over time, hopefully leading to fewer bugs.
>
>Tabs + a variable number spaces to match up logically with the
>previous line is O.K.  Tabs + exactly two spaces is what I objected
>to.  I only posted due to being the originator of the Linux Kernel Emacs
>cc-mode style and cc-mode works like the former.
>
>For whatever it's worth, my sentiments are on the David Miller side,
>having been the lucky recipient of format changes only patch bombs
>before.  I suppose you should be glad you don't have someone running
>a spell checker on the entire source code.

We have these people too. And by large, I find spell fixes
better than oh-I-decided-to-run-checkpatch-on-existing-code bombs.
