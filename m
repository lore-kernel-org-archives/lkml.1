Return-Path: <linux-kernel-owner+w=401wt.eu-S965250AbXG0Wwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965250AbXG0Wwd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 18:52:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936101AbXG0WwX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 18:52:23 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:16165 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933968AbXG0WwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 18:52:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=pVijbKzGKqhQfS2PNHckOZyHfVZlbFxTEq0piUe1g1zWvkLWPewsO5jSkaFqjXJ1RAQd3He/qR1Dv00UyzmAYNNFumIZYBzOVB8TPBEwrHDSRgottMaJbg1Am33dc9J1BXQPTUrko/X0zmfa3nmfDhakZu6e9U6keZVM6R5ZL18=
Message-ID: <7fedbc910707271552x71010f82o8455c17b21f80eab@mail.gmail.com>
Date: Sat, 28 Jul 2007 00:52:22 +0200
From: shacky <shacky83@gmail.com>
To: "Jesper Juhl" <jesper.juhl@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Kernel modules compilation
In-Reply-To: <9a8748490707271542s13862269h79f85d4171233f47@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <7fedbc910707271211v2ac2c927k3dd8fec8643ee250@mail.gmail.com>
	 <9a8748490707271303h7f5187ffk31d211c34fd885bf@mail.gmail.com>
	 <7fedbc910707271438t183bab6bxe295f161a5ec0fba@mail.gmail.com>
	 <9a8748490707271542s13862269h79f85d4171233f47@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Symbol: USB [=y]
> Prompt: Support for Host-side USB
>   Defined at drivers/usb/Kconfig:51
>   Depends on: USB_SUPPORT && USB_ARCH_HAS_HCD
>   Location:
>     -> Device Drivers
>       -> USB support (USB_SUPPORT [=y])

Could you tell me how you found them, please?

> Hint: In menuconfig, type "/" to search.

Thank you very much!

> Not really. Your distribution could be loading a ton of modules that
> you don't really need. 'lsmod' will just show you what is currently
> loaded, but that that doesn't necessarily mean that all those modules
> are really needed.

Ok, how I can know what modules are needed and what not? Only knowing
the hardware of my system?

Another question please, what the symbol "---" near a kernel
configuration entry in menuconfig means? This entry is activated (with
* or M) or not?
