Return-Path: <linux-kernel-owner+w=401wt.eu-S1756670AbXIWGCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670AbXIWGCS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 02:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753036AbXIWGCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 02:02:10 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:51769 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752946AbXIWGCK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 02:02:10 -0400
Date: Sun, 23 Sep 2007 08:03:35 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Oleg Verych <olecom@flower.upol.cz>
Cc: Jan Engelhardt <jengelh@computergmbh.de>, zippel@linux-m68k.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Unfortunate infinite make recursion
Message-ID: <20070923060335.GA22208@uranus.ravnborg.org>
References: <Pine.LNX.4.64.0709221319440.15712@fbirervta.pbzchgretzou.qr> <E1IZ788-0003LZ-Qs@flower> <20070922204002.GA31873@uranus.ravnborg.org> <20070922222311.GQ24301@flower.upol.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070922222311.GQ24301@flower.upol.cz>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Please Oleg.
> > You know very well that most people will not have their kernel src RO.
> 
> Sure, if it will be not comfortable.
> 
> But if kbuild deals with this transparently, it must be OK. Brokenness
> due to binutils, kbuild, root user bugs won't garbage source. Only thing
> to ask from experienced users *and* kernel developers, is
> `useradd kbuild`, everything else will not bother anybody.
Better would be to fix the bugs where we today clobber the sources.
Care to point out the exact cases you see.

	Sam
