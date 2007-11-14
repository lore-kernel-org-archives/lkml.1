Return-Path: <linux-kernel-owner+w=401wt.eu-S1763239AbXKNGlF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763239AbXKNGlF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 01:41:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761617AbXKNGkz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 01:40:55 -0500
Received: from ro-out-1112.google.com ([72.14.202.182]:37639 "EHLO
	ro-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759054AbXKNGky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 01:40:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=nt2VastEEWpb4/hn1kfBHAeGjn+vUb3KGP1n0/fbncGEDMnh9eCT8cUYVXaQgG1CXghDwty/rRQzSRFWEmhdGpDaUAi35Io3FszMlW+CvNMIuHcb8TjCGbCZu1L7QHXA69ezLgo1xlKAp7QotuT89Va7Y8dJMhkp130mdpHmKdQ=
Message-ID: <f17812d70711132240m359fcd5doac56ab06bfe76f69@mail.gmail.com>
Date: Wed, 14 Nov 2007 14:40:53 +0800
From: "eric miao" <eric.y.miao@gmail.com>
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: [patch/rfc 1/4] GPIO implementation framework
Cc: "Linux Kernel list" <linux-kernel@vger.kernel.org>,
       "Felipe Balbi" <felipebalbi@users.sourceforge.net>,
       "Bill Gatliff" <bgat@billgatliff.com>,
       "Haavard Skinnemoen" <hskinnemoen@atmel.com>,
       "Andrew Victor" <andrew@sanpeople.com>,
       "Tony Lindgren" <tony@atomide.com>, "Jean Delvare" <khali@linux-fr.org>,
       "Kevin Hilman" <khilman@mvista.com>, "Paul Mundt" <lethal@linux-sh.org>,
       "Ben Dooks" <ben@trinity.fluff.org>
In-Reply-To: <200711131930.19878.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200710291809.29936.david-b@pacbell.net>
	 <200711131106.11277.david-b@pacbell.net>
	 <f17812d70711131657wbdcc089kadb6024a47ad4a3@mail.gmail.com>
	 <200711131930.19878.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 14, 2007 11:30 AM, David Brownell <david-b@pacbell.net> wrote:
> On Tuesday 13 November 2007, eric miao wrote:
> > > > Can we use "per gpio based" structure instead of "per gpio_chip" based one,
> > > > just like what the generic IRQ layer is doing nowadays?
> > >
> > > We "can" do most anything. What would that improve though?
>
> ... What would that improve, though?  Your followup posts
> still don't answer that question for me.  I see the code,
> but don't have an answer to that question.
>

to be honest, I don't feel like the holes. Put restrictions on the numbering
of GPIOs might not be a good idea either.

>
>
>



-- 
Cheers
- eric
