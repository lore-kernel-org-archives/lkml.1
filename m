Return-Path: <linux-kernel-owner+w=401wt.eu-S1757499AbZJBRP5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757499AbZJBRP5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 13:15:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753645AbZJBRP5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 13:15:57 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35637 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753667AbZJBRP4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 13:15:56 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Fabio Comolli <fabio.comolli@gmail.com>
Subject: Re: [Bug #13943] WARNING: at net/mac80211/mlme.c:2292 with ath5k
Date: Fri, 2 Oct 2009 19:17:31 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rjw; KDE/4.3.1; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Luis R. Rodriguez" <mcgrof@gmail.com>
References: <3onW63eFtRF.A.xXH.oMTxKB@chimera> <COE24pZSBH.A.A5C.VOTxKB@chimera> <b637ec0b0910020012n57e110cbl180aa5bda318e5d5@mail.gmail.com>
In-Reply-To: <b637ec0b0910020012n57e110cbl180aa5bda318e5d5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200910021917.31509.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 October 2009, Fabio Comolli wrote:
> Hi.
> I suppose this is still valid. I had to work around it by rfkill-ing
> the device during the suspend process and reenabling at resume time.

Thanks for the update.

> I can try to reproduce it with 2.6.31.1 if you want it.

In fact I'm more interested in whether or not it's still present in the Linus'
tree.

Thanks,
Rafael
