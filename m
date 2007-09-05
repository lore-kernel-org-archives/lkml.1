Return-Path: <linux-kernel-owner+w=401wt.eu-S1757676AbXIEULW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757676AbXIEULW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 16:11:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756637AbXIEULN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 16:11:13 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:43432 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755717AbXIEULM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 16:11:12 -0400
Date: Wed, 5 Sep 2007 22:12:35 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: building a specific in-tree module is currently a bit broken
Message-ID: <20070905201235.GC30812@uranus.ravnborg.org>
References: <Pine.LNX.4.64.0709050509150.27539@localhost.localdomain> <6bffcb0e0709050237m7d948782iffec36253c6fccb2@mail.gmail.com> <Pine.LNX.4.64.0709051142080.5419@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0709051142080.5419@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 05, 2007 at 11:43:15AM +0200, Jan Engelhardt wrote:
> 
> Also note that visor will not have any symvers until you have
> a Module.symvers (which, ironically, is created at the end of "make vmlinux")

Yeaa - it is hard to create it before we have vmlinux.

	Sam
