Return-Path: <linux-kernel-owner+w=401wt.eu-S1751357AbXCHDJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751357AbXCHDJ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 22:09:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751341AbXCHDJ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 22:09:26 -0500
Received: from smtp.osdl.org ([65.172.181.24]:45590 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751134AbXCHDJY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 22:09:24 -0500
Date: Wed, 7 Mar 2007 19:06:46 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dan Williams <dcbw@redhat.com>
cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       stable@kernel.org, jeff@garzik.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       netdev@vger.kernel.org, thomas@archlinux.org,
       val_henson@linux.intel.com, samuel.thibault@ens-lyon.org
Subject: Re: [patch 097/101] revert "drivers/net/tulip/dmfe: support basic
 carrier detection"
In-Reply-To: <1173321712.12017.8.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0703071906060.10832@woody.linux-foundation.org>
References: <20070307171035.150802805@mini.kroah.org> 
 <20070307171657.461008445@mini.kroah.org>  <20070307101444.52cb2146@freekitty>
 <1173321712.12017.8.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 Mar 2007, Dan Williams wrote:
> 
> Definitely right.  If it doesn't work for your card, it needs to be
> fixed for your card.

Well, regressions are regressions. And they are a *lot* more important 
than any new features. If it doesn't work, it gets reverted.

		Linus
