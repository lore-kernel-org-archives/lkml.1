Return-Path: <linux-kernel-owner+w=401wt.eu-S1754689AbZCBOsn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689AbZCBOsn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 09:48:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752203AbZCBOsf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 09:48:35 -0500
Received: from smtp20.orange.fr ([193.252.22.31]:2301 "EHLO smtp20.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752126AbZCBOse (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 09:48:34 -0500
X-ME-UUID: 20090302144832321.4E6041C00059@mwinf2024.orange.fr
Subject: Re: usb hotplug and hooking
From: Xavier Bestel <xavier.bestel@free.fr>
To: Oguz Yarimtepe <comp.ogz@gmail.com>
Cc: Oliver Neukum <oliver@neukum.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20831c740903020633r40cc3a3fh5eb74eacd9026d3e@mail.gmail.com>
References: <20831c740903020539h68f62f2fj1575408d89050d25@mail.gmail.com>
	 <200903021513.01356.oliver@neukum.org>
	 <20831c740903020633r40cc3a3fh5eb74eacd9026d3e@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 02 Mar 2009 15:48:10 +0100
Message-Id: <1236005290.10675.360.camel@skunk>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-02 at 16:33 +0200, Oguz Yarimtepe wrote:
> I will look at the udev scripting. I don't need a GUI, yet. I will
> just communicate with the usb device, check its files and if an
> authorized software is found (will use asymmetric cryptography) will
> load it.  I can write the software that will do the mentioned things.
> I just don't know the hooking part. But udev is a good start. Thanks.

Have a look at halevt:
http://www.environnement.ens.fr/perso/dumas/halevt.html

HTH,
	Xav


