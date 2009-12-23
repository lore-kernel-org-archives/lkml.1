Return-Path: <linux-kernel-owner+w=401wt.eu-S1757005AbZLWUsL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757005AbZLWUsL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 15:48:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755067AbZLWUsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 15:48:10 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:52366 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752654AbZLWUsE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 15:48:04 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] [RFT] Input: speed up suspend/shutdown for PS/2 mice and keyboards
Date: Wed, 23 Dec 2009 21:48:47 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc1-tst; KDE/4.3.3; x86_64; ; )
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Linux Input <linux-input@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.0912211528550.2643-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0912211528550.2643-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912232148.47172.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 December 2009, Alan Stern wrote:
> On Sun, 20 Dec 2009, Dmitry Torokhov wrote:
> 
> > Hi,
> > 
> > I am asking everyone to give this patch a try. It is reported to speed
> > up suspend process, however there is a risk that there are boxes out
> > there that do require full reset and I would prefer to know that sooner
> > than later.
> 
> It works okay on my machine (Intel ICH4).

Likewise on my Toshiba Portege R500 (ICH7).

[Of course, it also works on my other test boxes, the Wind has ICH7 like the
Toshiba, and the nx6325 has ATI SB400).

Rafael
