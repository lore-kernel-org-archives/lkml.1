Return-Path: <linux-kernel-owner+w=401wt.eu-S935909AbZLPXGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935909AbZLPXGT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 18:06:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935308AbZLPXGO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 18:06:14 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:16794 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935312AbZLPXGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 18:06:13 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,5834"; a="30130240"
Subject: Re: GPIO support for HTC Dream
From: Daniel Walker <dwalker@codeaurora.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: H Hartley Sweeten <hartleys@visionengravers.com>,
       Arve Hj?nnev?g <arve@android.com>, Ryan Mallon <ryan@bluewatersys.com>,
       Iliyan Malchev <malchev@google.com>,
       Brian Swetland <swetland@google.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
In-Reply-To: <20091216225342.GH21102@elf.ucw.cz>
References: <4B1EB57D.6070408@bluewatersys.com>
	 <20091208214658.GC4164@elf.ucw.cz> <4B1ECEEE.3000209@bluewatersys.com>
	 <4B203575.6050407@bluewatersys.com> <20091210172458.GJ19454@elf.ucw.cz>
	 <4B2150B7.3040207@bluewatersys.com>
	 <BD79186B4FD85F4B8E60E381CAEE190901FB0F92@mi8nycmail19.Mi8.com>
	 <20091211221015.GB24456@elf.ucw.cz>
	 <d6200be20912111440k427c5013j2b17191bcbae2d52@mail.gmail.com>
	 <BD79186B4FD85F4B8E60E381CAEE190901FB10EB@mi8nycmail19.Mi8.com>
	 <20091216225342.GH21102@elf.ucw.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Dec 2009 15:03:41 -0800
Message-ID: <1261004621.10141.82.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-16 at 23:53 +0100, Pavel Machek wrote:

> > Where is the msm tree located?  mach-msm in mainline doesn't appea to
> > have _any_ gpio support.  
> 
> Right.
> 
> > Is Pavel's implementation generic enough to
> > work with any msm based board?
> 
> I think so but I'm not sure; thats what I wanted google to
> clarify. Lets keep it dream-specific for now...

I don't think so, since it was something added by HTC.. I'm pretty sure
the generic msm gpio's are accessed differently.

Daniel

