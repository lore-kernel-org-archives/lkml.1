Return-Path: <linux-kernel-owner+w=401wt.eu-S1758173AbYDUAFx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758173AbYDUAFx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 20:05:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753335AbYDUAFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 20:05:42 -0400
Received: from hpsmtp-eml17.kpnxchange.com ([213.75.38.117]:25886 "EHLO
	hpsmtp-eml17.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753183AbYDUAFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 20:05:42 -0400
From: Frans Pop <elendil@planet.nl>
To: Jeff Garzik <jeff@garzik.org>
Subject: ISDN testing (was: [git patches] ISDN cleanups (modularization prep))
Date: Mon, 21 Apr 2008 02:05:38 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       isdn4linux@listserv.isdn4linux.de
References: <20080420223959.GA17998@havoc.gtf.org>
In-reply-To: <20080420223959.GA17998@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804210205.38891.elendil@planet.nl>
X-OriginalArrivalTime: 21 Apr 2008 00:05:39.0837 (UTC) FILETIME=[6EE002D0:01C8A343]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Dropping private CCs.)

Jeff Garzik wrote:
> - "isn't ISDN dead?"  Apparently, no it's not :)
> 
> - "don't waste your time, drop these drivers and get mISDN into the
>   kernel instead" -- based on discussion it does sound like mISDN should
>   get into the kernel.  Until these drivers are dropped, however, my
>   patches remain appropriate.
> 
> And in case people are curious, #isdn-pci isn't ready for upstream yet
> for two main reasons: (1) two drivers remain unconverted, and (2) none
> of the changes have been tested, even once.

I have three different ISDN cards. However, since I've had ADSL since about 
3 years (on top of ISDN), I don't actually use it anymore.

I could be persuaded to do some testing though, or to donate some or all of 
my cards for that purpose.

For testing I'd at least need somewhere to connect to, preferably in NL.
I have no idea if I could still connect to my previous provider using ISDN. 
The account was transferred to a different provider about 2 years ago, but 
the mail accounts with the old provider are still active.

The cards I have are:
- Teles 16.3 ISA -- worked way back when with Debian Woody
- ITK ix1-micro 2.1 ISA
- Eicon Diva 2.01 PCI

I also have a test box I can put them in :-)

Looks like I can still at least successfully load the hisax driver with 
2.6.18 for the Teles card. For the last two I'm not sure if I ever had them 
working with Linux (or even if I tried).

Cheers,
FJP
