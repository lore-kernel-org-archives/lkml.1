Return-Path: <linux-kernel-owner+w=401wt.eu-S932377AbZLNR5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932377AbZLNR5U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 12:57:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932362AbZLNR5R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 12:57:17 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:9538 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932349AbZLNR5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 12:57:16 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,5832"; a="29879316"
Subject: Re: GPIO support for HTC Dream
From: Daniel Walker <dwalker@codeaurora.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: H Hartley Sweeten <hartleys@visionengravers.com>,
       Ryan Mallon <ryan@bluewatersys.com>,
       Iliyan Malchev <malchev@google.com>,
       Brian Swetland <swetland@google.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       Arve Hj?nnev?g <arve@android.com>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
In-Reply-To: <20091214064545.GK5114@elf.ucw.cz>
References: <20091208102842.GH12264@elf.ucw.cz>
	 <4B1EB57D.6070408@bluewatersys.com> <20091208214658.GC4164@elf.ucw.cz>
	 <4B1ECEEE.3000209@bluewatersys.com> <4B203575.6050407@bluewatersys.com>
	 <20091210172458.GJ19454@elf.ucw.cz> <4B2150B7.3040207@bluewatersys.com>
	 <BD79186B4FD85F4B8E60E381CAEE190901FB0F92@mi8nycmail19.Mi8.com>
	 <20091211221015.GB24456@elf.ucw.cz>
	 <BD79186B4FD85F4B8E60E381CAEE190901FB10EA@mi8nycmail19.Mi8.com>
	 <20091214064545.GK5114@elf.ucw.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Dec 2009 09:54:53 -0800
Message-ID: <1260813293.13078.15.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-12-14 at 07:45 +0100, Pavel Machek wrote:
> Hi!
> 
> > This looks MUCH better!
> 
> Thanks :-).
> 
> > > arch/arm/Kconfig                     |    1
> > > arch/arm/mach-msm/board-dream-gpio.c |  327 +++++++++--------------------------
> ...
> > Please update (or remove) this diffstat.  It no longer matches the patch.
> 
> I was just showing differences to _previous_ version, not what I was sending.
> 
> > Ok.  The hardware still seems a bit strange. Is there any datasheet
> > available?
> 
> I don't think there is one. Daniel, can you help here?

I don't know if there is one or not (I'd guess not).. I can't release
documents, but I could try to address specific questions or find people
to answer specific questions.

Daniel

