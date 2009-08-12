Return-Path: <linux-kernel-owner+w=401wt.eu-S1754802AbZHLUR4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802AbZHLUR4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 16:17:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754741AbZHLURz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 16:17:55 -0400
Received: from mail-fx0-f228.google.com ([209.85.220.228]:34908 "EHLO
	mail-fx0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754716AbZHLURy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 16:17:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Q7YjW7oVkmW7Ifo1TLxJVevboZq4qq7dZXxfGonN/WSdM8/tzihxIubBclTHxDxGcs
         veIZJuxawJIKEFQmj2iMEfh7Luyld+VFSCLWZ4nvfZdiBzVwGdwftBBRmGCkcKlebDLo
         DSvcu0Ntl/XNHIIn2cyV1CcOLCAzlsXigDZlI=
MIME-Version: 1.0
In-Reply-To: <20090812194838.GB12117@n2100.arm.linux.org.uk>
References: <20090806113104.GK31370@elf.ucw.cz> <4A7ACC8D.7030706@xenontk.org>
	 <20090806124048.GD27773@flint.arm.linux.org.uk>
	 <1249563730.10297.13.camel@Joe-Laptop.home>
	 <20090806133349.GF27773@flint.arm.linux.org.uk>
	 <1249568614.10297.20.camel@Joe-Laptop.home>
	 <20090806150322.GX2080@trinity.fluff.org>
	 <1249948147.8895.96.camel@Joe-Laptop.home>
	 <20090812115520.GI24339@elf.ucw.cz>
	 <20090812194838.GB12117@n2100.arm.linux.org.uk>
Date: Wed, 12 Aug 2009 23:17:54 +0300
X-Google-Sender-Auth: 792b35b20474d5db
Message-ID: <84144f020908121317g64551a2cu1b960f44ed5d0d9@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: Add "L: linux-arm@vger.kernel.org" to ARM 
	sections
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Pavel Machek <pavel@ucw.cz>, Joe Perches <joe@perches.com>,
       Ben Dooks <ben-linux@fluff.org>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       David John <davidjon@xenontk.org>, Erik Mouw <mouw@nl.linux.org>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Krzysztof Halasa <khc@pm.waw.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

On Wed, Aug 12, 2009 at 10:48 PM, Russell King - ARM
Linux<linux@arm.linux.org.uk> wrote:
> I haven't noticed a great rush of support for Joe's patch, which
> could mean that people here really aren't that bothered - maybe
> they just aren't "open list" zealots like some people seem to be.

I for one support open lists because subscriber-only lists are a PITA
for contributors who send out patches to multiple subsystems. However,
if you (and the rest of the arm people) don't see the value of opening
the list up, why do you expect people to rush to support Joe's patch?
It's you who is losing out on contributors and if you don't see that
(or don't agree), you probably should keep the list subscriber-only,
no?

                        Pekka
