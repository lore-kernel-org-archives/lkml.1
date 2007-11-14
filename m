Return-Path: <linux-kernel-owner+w=401wt.eu-S1762470AbXKNDzV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762470AbXKNDzV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 22:55:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756873AbXKNDyr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 22:54:47 -0500
Received: from smtp114.sbc.mail.mud.yahoo.com ([68.142.198.213]:20688 "HELO
	smtp114.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754894AbXKNDyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 22:54:46 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=DKlsZdCGVte/CGk6sSzxEW+7AFJ8fLCuDJzTYkXh12E0NJHoaf+m12WuDcEk1q0VEz/nxZWT8hIO4dJmGN5NjmqhoXvM0mr3Xc7jnkq0a2UoXG43kDVyizxvgdJ1u09sVkcjdPelEvH97g4qYVtKzDXXheSDtyn2PpgTi56QRgo=  ;
X-YMail-OSG: mzeoYs0VM1ldulCfPL.0_TusexTVvpWBhyjNZbrBj5zsHPJtwj8pJ.GpIg5q72PzsoPyhOO.TQ--
From: David Brownell <david-b@pacbell.net>
To: "eric miao" <eric.y.miao@gmail.com>
Subject: Re: [patch/rfc 1/4] GPIO implementation framework
Date: Tue, 13 Nov 2007 19:30:19 -0800
User-Agent: KMail/1.9.6
Cc: "Linux Kernel list" <linux-kernel@vger.kernel.org>,
       "Felipe Balbi" <felipebalbi@users.sourceforge.net>,
       "Bill Gatliff" <bgat@billgatliff.com>,
       "Haavard Skinnemoen" <hskinnemoen@atmel.com>,
       "Andrew Victor" <andrew@sanpeople.com>,
       "Tony Lindgren" <tony@atomide.com>, "Jean Delvare" <khali@linux-fr.org>,
       "Kevin Hilman" <khilman@mvista.com>, "Paul Mundt" <lethal@linux-sh.org>,
       "Ben Dooks" <ben@trinity.fluff.org>
References: <200710291809.29936.david-b@pacbell.net> <200711131106.11277.david-b@pacbell.net> <f17812d70711131657wbdcc089kadb6024a47ad4a3@mail.gmail.com>
In-Reply-To: <f17812d70711131657wbdcc089kadb6024a47ad4a3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200711131930.19878.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 November 2007, eric miao wrote:
> > > Can we use "per gpio based" structure instead of "per gpio_chip" based one,
> > > just like what the generic IRQ layer is doing nowadays?
> >
> > We "can" do most anything.  What would that improve though?

... What would that improve, though?  Your followup posts
still don't answer that question for me.  I see the code,
but don't have an answer to that question.



