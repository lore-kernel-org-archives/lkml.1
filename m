Return-Path: <linux-kernel-owner+w=401wt.eu-S1752419AbZAZIpe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752419AbZAZIpe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 03:45:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750939AbZAZIpY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 03:45:24 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:59741 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbZAZIpX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 03:45:23 -0500
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: Michelle Konzack <linux4michelle@tamay-dogan.net>
Subject: Re: System hang (and other problems) with cdc_acm
Date: Mon, 26 Jan 2009 09:45:52 +0100
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
References: <e4cb19870901191220y622e0120m512596656c72bbf3@mail.gmail.com> <20090125232753.db40c160.akpm@linux-foundation.org> <20090126081904.GI25958@tamay-dogan.net>
In-Reply-To: <20090126081904.GI25958@tamay-dogan.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200901260945.52972.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Monday 26 January 2009 09:19:04 schrieb Michelle Konzack:
> > > to debug this; the Caps Lock light isn't flashing, so I'm not sure if
> > > it's a panic or just a hang.  Second, if I read one of the TTYs using
> > > "cat", I get a ton of blank lines.  To make any sense of the data
> > > stream, I have to do cat /dev/ttyACM0 | grep -v "^$".
> > > 
> > > If anyone could help me debug this, I'd be greatly appreciative.
> 
> Same problem here...
> 
> My Router is based on Debian Etch with
> 
> Linux router 2.6.18-6-686 #1 SMP Fri Dec 12 16:48:28 UTC 2008 i686 GNU/Linux
> 
> and even if I install 2.6.26 it is the same effect.
> 
> I am using a cell-phone "Nokia 6120 classic" and my german GSM  Provider
> is O2/Telefonica.  I get without any problems  550 kByte/Sec,  but  then
> from one second to another 2-5 kByte/Sec.

What makes you think that it is the same problem? It doesn't hang your
system, does it? If so, can you please post "dmesg" of one of the incidents
and "lsusb -v"?

	Regards
		Oliver

