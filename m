Return-Path: <linux-kernel-owner+w=401wt.eu-S1760790AbXHUGxn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760790AbXHUGxn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 02:53:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759975AbXHUGwp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 02:52:45 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44711 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759963AbXHUGwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 02:52:43 -0400
Date: Mon, 20 Aug 2007 23:52:11 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Brownell <david-b@pacbell.net>
cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-usb-devel@lists.sourceforge.net, Greg KH <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       "Stuart_Hayes@Dell.com" <Stuart_Hayes@dell.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Exner <dex@dragonslave.de>
Subject: Re: [linux-usb-devel] [4/4] 2.6.23-rc3: known regressions
In-Reply-To: <200708202334.38261.david-b@pacbell.net>
Message-ID: <alpine.LFD.0.999.0708202348460.30176@woody.linux-foundation.org>
References: <46C098FD.1030601@googlemail.com>
 <alpine.LFD.0.999.0708202201580.30176@woody.linux-foundation.org>
 <alpine.LFD.0.999.0708202255130.30176@woody.linux-foundation.org>
 <200708202334.38261.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 20 Aug 2007, David Brownell wrote:
> 
> Try disabling USB_SUSPEND ... the rather aggressive powersave
> mechanism (autosuspend defaulting to always ON) has made lots
> of trouble.  I think that default will change...

It's already disabled - so that's not it.

		Linus
