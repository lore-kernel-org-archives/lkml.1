Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757530Ab0AOMwg (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 07:52:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757429Ab0AOMwg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 07:52:36 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:53773 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757171Ab0AOMwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 07:52:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=Y+xjNqT80bHefcsGsliXyx3w5rx9xfFE/cCxOH7S3ZiRHvGCs5chfiyHwsyrstTw9d
         /Kt0PIwWK+2Df4hn4FYSEM5CtVcs+Y6XquGWY6ElH4NNT1WLWdxMxrNhIHhJjt9frCl3
         UDsWY87fBasb2LKmsyZnD/wxyQs6WDiEhVbHg=
MIME-Version: 1.0
In-Reply-To: <4B506378.3090507@s5r6.in-berlin.de>
References: <4B502C6B.7000802@s5r6.in-berlin.de>
	 <20100115.005445.263291449.davem@davemloft.net>
	 <tkrat.e88dd4dbf17f9bde@s5r6.in-berlin.de>
	 <20100115.012233.202457727.davem@davemloft.net>
	 <Pine.LNX.4.64.1001151039080.23543@ask.diku.dk>
	 <84144f021001150149u3b784d26g1822be6c5c3ecbf@mail.gmail.com>
	 <Pine.LNX.4.64.1001151101320.23543@ask.diku.dk>
	 <20100115110845.GB28625@sirena.org.uk>
	 <Pine.LNX.4.64.1001151303580.23543@ask.diku.dk>
	 <4B506378.3090507@s5r6.in-berlin.de>
Date: Fri, 15 Jan 2010 14:52:33 +0200
X-Google-Sender-Auth: 7bea78f5ff207d23
Message-ID: <84144f021001150452h22563ffaw14f74cc449950982@mail.gmail.com>
Subject: Re: Changelog quality
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Julia Lawall <julia@diku.dk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        David Miller <davem@davemloft.net>, adi@hexapodia.org,
        nm127@freemail.hu, david.vrabel@csr.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, cocci@diku.dk,
        Andrew Morton <akpm@linux-foundation.org>,
        Nicolas Palix <npalix@diku.dk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stefan,

On Fri, Jan 15, 2010 at 2:45 PM, Stefan Richter
<stefanr@s5r6.in-berlin.de> wrote:
> I guess many of these scripts are also applicable to other C programs.

Well, most of the ones I've seen are related to kernel APIs or idioms
which are not meaningful to other projects so I don't know if that's
true or not. I don't have a full solution here but I'm just trying to
find a middle ground because I tend to agree with both of you. Yes,
it's damn ugly to have the scripts embedded in the changelog but on
the other hand I _really_ want to see "what the hell found the bug"
too.

                        Pekka
