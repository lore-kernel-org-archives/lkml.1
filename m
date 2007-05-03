Return-Path: <linux-kernel-owner+w=401wt.eu-S1031318AbXECUuL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031318AbXECUuL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 16:50:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031328AbXECUuL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 16:50:11 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:47552 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031318AbXECUtx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 16:49:53 -0400
Date: Thu, 3 May 2007 22:50:45 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Trent Piepho <xyzzy@speakeasy.org>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [v4l-dvb-maintainer] [PATCH 35/36] Use menuconfig objects II - DVB
Message-ID: <20070503205045.GC18539@uranus.ravnborg.org>
References: <Pine.LNX.4.61.0704301225060.29151@yvahk01.tjqt.qr> <Pine.LNX.4.61.0704301429450.29151@yvahk01.tjqt.qr> <1178129426.29579.17.camel@localhost> <Pine.LNX.4.58.0705021436050.504@shell2.speakeasy.net> <Pine.LNX.4.61.0705030855000.18504@yvahk01.tjqt.qr> <1178195820.12651.28.camel@localhost> <Pine.LNX.4.61.0705031453360.18504@yvahk01.tjqt.qr> <Pine.LNX.4.58.0705031247300.32689@shell2.speakeasy.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0705031247300.32689@shell2.speakeasy.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> The out of tree v4l-dvb build system uses the same Kconfig/Makefiles as it
> does in the kernel.  This part of the kernel build system is not easily
> exported to out of tree modules, so we have some scripts to handle this.

Can you elaborate of what was causing your troubles.
Maybe kbuild/kconfig can be improved in this respect..

	Sam
