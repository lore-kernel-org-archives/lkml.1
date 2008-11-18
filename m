Return-Path: <linux-kernel-owner+w=401wt.eu-S1756226AbYKRRSq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226AbYKRRSq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 12:18:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755807AbYKRRSD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 12:18:03 -0500
Received: from smtp2b.orange.fr ([80.12.242.146]:42458 "EHLO smtp2b.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756108AbYKRRSA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 12:18:00 -0500
X-ME-UUID: 20081118171758470.72DBF700008C@mwinf2b16.orange.fr
Subject: Re: Developing non-commercial drivers ?
From: Xavier Bestel <xavier.bestel@free.fr>
To: Fredrik =?ISO-8859-1?Q?Markstr=F6m?= 
	<fredrik.markstrom@avalonenterprise.com>
Cc: Robert Hancock <hancockr@shaw.ca>, linux-kernel@vger.kernel.org
In-Reply-To: <7a9e70560811180852y9eb2bf6s8682609dcb10fd9f@mail.gmail.com>
References: <fc262dee0811180816k29cc93aas51c2c47ede2c7a1@mail.gmail.com>
	 <4922ED5A.3030808@shaw.ca>
	 <7a9e70560811180852y9eb2bf6s8682609dcb10fd9f@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Date: Tue, 18 Nov 2008 18:17:47 +0100
Message-Id: <1227028667.12044.9.camel@skunk>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5) 
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-11-18 at 17:52 +0100, Fredrik Markström wrote:
> Thanks for the prompt respons.
> 
> I do agree that it would be better for everyone to release it under
> GPL and I have already expressed that to our customer.
> 
> At this point I feel that we have two possibilities, help our customer
> violate GPL or say no to the project. I'd prefer a third option where
> I could tell the customer that we can setup the project in a certain
> way (some "cleanroom" setup ?) to ensure that the results can not be
> considered derived work.
> 
> Is your short answer also the definite answer considering this ?

Why not distributing the driver to your client under the same licence
terms as the kernel (i.e. GPLv2, tell him you're legally tied to it),
and then let your client handle distribution to the end-user the way it
sees fit ?
That way you come out clean, and your client gets to resolve the
eventual legal troubles himself.

	Xav


