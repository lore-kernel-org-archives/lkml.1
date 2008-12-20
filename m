Return-Path: <linux-kernel-owner+w=401wt.eu-S1754063AbYLTP2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063AbYLTP2b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 10:28:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752016AbYLTP2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 10:28:23 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:60038 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955AbYLTP2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 10:28:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=LJKaP1MjPm8oD0OUiN2AYatmr2kuRGBD7Y/eyA71/PinezGCpuYyJtLYrHSYL8tWMK
         qqkQt4g49GYSAxJcEB7VfG8xUXrY4ci0zPyz18QeagF+s2OdxUVouAk0fLGX80HU/OoR
         B4H56C2+7ruHYiFgM66dBLAldOxs3NOqr+0Ys=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Alex Buell <alex.buell@munted.org.uk>
Subject: Re: [PATCH] New x86_64 boot logo
Date: Sat, 20 Dec 2008 16:28:15 +0100
User-Agent: KMail/1.8.2
Cc: Nick Warne <nick@ukfsn.org>, LKML <linux-kernel@vger.kernel.org>
References: <20081220105658.35ebd2bc@sauron.linicks.net> <20081220144232.5f00492d@lithium.local.net>
In-Reply-To: <20081220144232.5f00492d@lithium.local.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812201628.15522.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 20 December 2008 15:42, Alex Buell wrote:
> On Sat, 20 Dec 2008 10:56:58 +0000, I waved a wand and this message
> magically appears in front of Nick Warne:
> 
> > I have been running a full true 64 bit system now for a few months
> > (Slamd64), and this made me think...
> > 
> > Introduce a new fb boot logo to reflect running a x86_64
> > kernel/system.
> 
> Any objections to overlaying the usual 32bit Penguin's feet with 32? 

I'd say don't bother. There ane more useful things to do.
--
vda
