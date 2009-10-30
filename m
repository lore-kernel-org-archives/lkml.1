Return-Path: <linux-kernel-owner+w=401wt.eu-S932213AbZJ3OTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932213AbZJ3OTz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 10:19:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932128AbZJ3OTy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 10:19:54 -0400
Received: from icculus.org ([67.106.77.212]:45556 "EHLO icculus.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932113AbZJ3OTx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 10:19:53 -0400
Date: Fri, 30 Oct 2009 10:19:54 -0400 (EDT)
From: "Ryan C. Gordon" <icculus@icculus.org>
X-X-Sender: icculus@caridad.icculuslan
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 2/2] binfmt_elf: FatELF support for kernel
 modules.
In-Reply-To: <20091030103214.463042fb@lxorguk.ukuu.org.uk>
Message-ID: <alpine.OSX.1.10.0910301018170.30808@caridad.icculuslan>
References: <alpine.DEB.2.00.0910190422090.13303@andre.icculuslan> <4ADD0086.9060304@goop.org> <alpine.DEB.2.00.0910200043200.18342@andre.icculuslan> <4AE22D04.50708@goop.org> <20091024121421.2e530635@lxorguk.ukuu.org.uk> <4AE5F4FB.3000506@goop.org>
 <alpine.DEB.2.00.0910292224560.4219@andre.icculuslan> <20091030103214.463042fb@lxorguk.ukuu.org.uk>
User-Agent: Alpine 1.10 (OSX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> And you still ignore the fundamental point that the kernel module search
> path typically includes the architecture anyway so you can simply install
> two module files. That makes this feature pointless.

The module loading patch is just for the sake of completeness, so if 
there's a hesitance to apply this part, I'm okay with that.

--ryan.

