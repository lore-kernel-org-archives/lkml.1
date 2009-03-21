Return-Path: <linux-kernel-owner+w=401wt.eu-S1756749AbZCUPI3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756749AbZCUPI3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 11:08:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752463AbZCUPIQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 11:08:16 -0400
Received: from mail-gx0-f208.google.com ([209.85.217.208]:50075 "EHLO
	mail-gx0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715AbZCUPIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 11:08:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=sz1xgCbr3KkRlmegYOehFfuF2W4OyRAjgWnBJ/nYCCHaeOfmuRc41HK4NpCiaLcHLD
         +fhbdSJ5U2Y0FxnnjphgAa7639pPvs4mU/W2KOQH/BH6xjL3axWF6kaNZ8DFTu0d6EbX
         bSjSd0eLdYKWKa3Pe7hb14wMaGtksJAzm0OSo=
MIME-Version: 1.0
In-Reply-To: <1237637375.5100.178.camel@johannes.local>
References: <MiincthRUSI.A.eKC.F4BvJB@chimera>
	 <b6a2187b0903181958ke11abe7tdcbc4efeb950954d@mail.gmail.com>
	 <b6a2187b0903182149x77e416ecuf73be2970173c601@mail.gmail.com>
	 <1237455534.5100.56.camel@johannes.local>
	 <b6a2187b0903192155q33510b57l9d5927538a0f4f99@mail.gmail.com>
	 <1237537967.5100.135.camel@johannes.local>
	 <b6a2187b0903200304l469e3eeet87c51b1cddb43ea8@mail.gmail.com>
	 <1237544033.5100.143.camel@johannes.local>
	 <b6a2187b0903200914r23d635c9obc55b30b7cc04382@mail.gmail.com>
	 <1237637375.5100.178.camel@johannes.local>
Date: Sat, 21 Mar 2009 23:08:11 +0800
Message-ID: <b6a2187b0903210808m7586fdc2g53e72aa269d6e353@mail.gmail.com>
Subject: Re: 2.6.29-rc8: Reported regressions from 2.6.28
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       "John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 21, 2009 at 8:09 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> Thing is that this works perfectly fine for me, on very similar
> hardware.

I've set hidden SSID + mac address filtering (only allow my notebook
MAC address) as well as 128 WEP. And no problem to associate with
non-hidden AP.

> OTOH, maybe it got _fixed_ again. Would you check wireless-testing
> (http://wireless.kernel.org/en/developers/Documentation#wireless-testing.git) for me? Or compat-wireless (http://wireless.kernel.org/en/users/Download)

I'll try that tomorrow. Seems a lot to pull from git.

Thanks,
Jeff.
