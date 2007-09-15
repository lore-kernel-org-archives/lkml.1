Return-Path: <linux-kernel-owner+w=401wt.eu-S1756358AbXIORm5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756358AbXIORm5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 13:42:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752808AbXIORmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 13:42:51 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:59120 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207AbXIORmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 13:42:50 -0400
Date: Sat, 15 Sep 2007 19:42:49 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Denys Vlasenko <vda.linux@googlemail.com>
cc: Andreas Schwab <schwab@suse.de>, Sam Ravnborg <sam@ravnborg.org>,
       Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] add consts where appropriate in sound/pci/hda/*
In-Reply-To: <200709151447.44890.vda.linux@googlemail.com>
Message-ID: <Pine.LNX.4.64.0709151942340.24423@fbirervta.pbzchgretzou.qr>
References: <200709141848.06027.vda.linux@googlemail.com>
 <200709151242.38464.vda.linux@googlemail.com> <jeps0kyue5.fsf@sykes.suse.de>
 <200709151447.44890.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 15 2007 14:47, Denys Vlasenko wrote:
>> Try size -A instead.
>
>thanks, didn't know that.
>
>$ size -A busybox
>busybox  :
>section       size        addr
>.init           28   134512788
>addr in decimal?! wow...

Try size -x instead.
