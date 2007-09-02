Return-Path: <linux-kernel-owner+w=401wt.eu-S966111AbXIBM2o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966111AbXIBM2o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 08:28:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757251AbXIBM2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 08:28:33 -0400
Received: from fresno.net.uniovi.es ([156.35.11.2]:55444 "EHLO
	FRESNO.NET.UNIOVI.ES" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755402AbXIBM2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 08:28:31 -0400
X-Greylist: delayed 4080 seconds by postgrey-1.27 at vger.kernel.org; Sun, 02 Sep 2007 08:28:31 EDT
Date: Sun, 02 Sep 2007 14:28:28 +0200 (CEST)
From: Igor Sobrado <igor@condmat1.ciencias.uniovi.es>
Subject: Re: Fwd: That whole "Linux stealing our code" thing
In-reply-to: <20070902115041.GM16016@stusta.de>
To: Adrian Bunk <bunk@kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Constantine A. Murenin" <mureninc@gmail.com>,
       Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Message-id: <Pine.LNX.4.64.0709021416130.6181@condmat1.ciencias.uniovi.es>
MIME-version: 1.0
Content-type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Content-transfer-encoding: 7BIT
References: <200709010140.l811eq9H005896@cvs.openbsd.org>
 <f34ca13c0709010948v67b04b58lb098713dc38c4d6a@mail.gmail.com>
 <46D99FB7.6030505@garzik.org>
 <f34ca13c0709011037p221cb40fjf69651d1858df212@mail.gmail.com>
 <20070901205457.GK9260@stusta.de> <20070902113638.78fbd202@the-village.bc.nu>
 <Pine.LNX.4.64.0709021303001.4312@condmat1.ciencias.uniovi.es>
 <20070902115041.GM16016@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 Sep 2007, Adrian Bunk wrote:
> On Sun, Sep 02, 2007 at 01:20:27PM +0200, Igor Sobrado wrote:
>> Reyk code was never dual licensed!  His code is under truly free licensing
>> terms (BSD).
>
> Jiri's patch touched both files containing BSD-only code by Reyk and
> code Reyk contributed to leaving the file dual licenced.

Ok.

> You mixed two completely different things in your email:
>
> 1. Jiri's patch (that was never merged into Linux) not only removed the
>   BSD header from dual licenced files but also from not dual licenced
>   files.
>
> 2. Theo accused Alan that telling people that it was OK to choose one
>   licence for dual licenced code was "advising people to break the law".
>
> Jiri's patch was legally not OK regarding 1. - there's no discussion
> regarding this.
>
> The point 2 is what the email of Theo that was forwarded to linux-kernel
> is about and what the discussion is about. That's quite a rude action
> by Theo unless he's able to prove that this accusation is correct.

When code is multi-licensed it must be distributed under *all* these 
licensing terms concurrently.  It is easy to understand.  Removing (or 
changing) the conditions that apply to the program from the source code 
and documentation *without* an authorization from all the author(s) is 
illegal.

So, a multi-licensed file remains multi-licensed except when all authors 
agree about a change in the licensing terms.  And it is clear on the BSD 
license that a modification of the distribution terms is illegal.  It is 
the first clause on the BSD license:

  * 1. Redistributions of source code must retain the above copyright
  *    notice, this list of conditions and the following disclaimer,
  *    without modification.

So, removing (or changing) the list of conditions on the BSD license is 
not allowed.

Igor.
