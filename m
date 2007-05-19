Return-Path: <linux-kernel-owner+w=401wt.eu-S1762110AbXESQNW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762110AbXESQNW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 12:13:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754518AbXESQNQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 12:13:16 -0400
Received: from mail-in-02.arcor-online.net ([151.189.21.42]:54241 "EHLO
	mail-in-02.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754488AbXESQNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 12:13:16 -0400
In-Reply-To: <464F167A.1090706@anagramm.de>
References: <200705190953.l4J9rjO2024613@harpo.it.uu.se> <464F167A.1090706@anagramm.de>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <c394a611c69fb750d458c089be118e8b@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: Mikael Pettersson <mikpe@it.uu.se>, linux-kernel@vger.kernel.org
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: gcc-4.2.0 breakage on powerpc?
Date: Sat, 19 May 2007 18:13:16 +0200
To: Clemens Koller <clemens.koller@anagramm.de>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Over here, the 2.6.21.1 Kernel _builds_ fine with gcc-4.2.0 on an 
> mpc8540 e500 powerpc
> (mpc8540_ads_defconfig)

Yeah, this problem likely doesn't show up on 32-bit platforms.

> but it just crashes silently on boot. But that's IMHO a
> DeviceTree/U-Boot issue I haven't solved yet.

Quite possible.  If you have any further problems, take
it to the linuxppc-dev list please.


Segher

