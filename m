Return-Path: <linux-kernel-owner+w=401wt.eu-S1756657AbZBFNsd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756657AbZBFNsd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 08:48:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751997AbZBFNsY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 08:48:24 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:32804 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776AbZBFNsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 08:48:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=lYGYOvpyI4Vl335mbaOn4Wbs0Anm81q4oN6PAS4+0C81rTvmNzFawPBg5dAvj86m5E
         jQlyoFp5sxJG+MFkOdbbXo/IczBGnv6xZpQ502K5hAz5zFn9o22V8hZ2CLiGzK7L2pEf
         Rqk2+ZPpOAY9w22BsR7cwPxu58IdlAsp5U5fA=
MIME-Version: 1.0
In-Reply-To: <1233921904.17724.181.camel@macbook.infradead.org>
References: <20090204184029.881610776@mini.kroah.org>
	 <20090204184602.GH25246@kroah.com> <1233791475.4612.24.camel@pasglop>
	 <1233921904.17724.181.camel@macbook.infradead.org>
Date: Fri, 6 Feb 2009 15:48:21 +0200
Message-ID: <46e1c7760902060548j6d5b12dcp25c443007507c9c8@mail.gmail.com>
Subject: Re: [patch 07/41] fbdev/atyfb: Fix DSP config on some PowerMacs & 
	PowerBooks
From: Risto Suominen <risto.suominen@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       stable@kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/2/6 David Woodhouse <dwmw2@infradead.org>:
> On Thu, 2009-02-05 at 10:51 +1100, Benjamin Herrenschmidt wrote:
>> My only possible worry with that one is the first generation clamshell
>> iBook which uses a Mobility M1 chip, for which we haven't had anybody
>> testing whether this would break it or not ...
>>
>> So if anybody with such a machine is reading this, please holler...
>
> I think I have one in the shed. That's a PowerBook1,1?
>

I think it should be either PowerBook2,1 or 2,2.

Risto
