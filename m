Return-Path: <linux-kernel-owner+w=401wt.eu-S1755703AbZDTTZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755703AbZDTTZY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 15:25:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753485AbZDTTY7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 15:24:59 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37489 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753651AbZDTTY6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 15:24:58 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [BISECTED] [REGRESSION] can't anymore even do a s2ram-s2disk-s2ram cycle on acer aspire 5720G
Date: Mon, 20 Apr 2009 21:24:46 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc2-rjw; KDE/4.2.2; x86_64; ; )
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "linux-usb" <linux-usb@vger.kernel.org>
References: <1239061976.4705.16.camel@maxim-laptop> <20090407072651.GC1408@ucw.cz>
In-Reply-To: <20090407072651.GC1408@ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904202124.47477.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 April 2009, Pavel Machek wrote:
> Hi!
> 
> > Also this commits narrows down the search, now it is clear that this is
> > usb related. No wonder bios pokes at usb on resume and stalls.....
> 
> So obvious next step is to compile-out usb support and see what
> happens?

Well, Maxim has already done more than that.  Please look a the entire thread.

Best,
Rafael
