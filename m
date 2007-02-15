Return-Path: <linux-kernel-owner+w=401wt.eu-S965441AbXBOKIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965441AbXBOKIR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 05:08:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965464AbXBOKIQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 05:08:16 -0500
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:53448 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965441AbXBOKIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 05:08:16 -0500
To: jdike@addtoit.com
CC: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net
In-reply-to: <20070215002205.GA8099@ccure.user-mode-linux.org> (message from
	Jeff Dike on Wed, 14 Feb 2007 19:22:05 -0500)
Subject: Re: [uml-devel] UML hang with 100% CPU
References: <E1HFEIB-0000nJ-00@dorka.pomaz.szeredi.hu> <20070208195711.GA6607@ccure.user-mode-linux.org> <E1HFFeC-0000wJ-00@dorka.pomaz.szeredi.hu> <20070215002205.GA8099@ccure.user-mode-linux.org>
Message-Id: <E1HHdWm-0005jr-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 15 Feb 2007 11:07:48 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Strangely enough after continuing in gdb, UML is back to normal, and I
> > can't make it hang any more.  It must be something timing related.
> 
> Can you see if the patch below fixes it?

Yay!  Got my nice fast UML back instead of ugly slow QEmu ;)

Seems to work perfectly now.

Thanks,
Miklos
