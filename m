Return-Path: <linux-kernel-owner+w=401wt.eu-S1755662AbYK0Mka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755662AbYK0Mka (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 07:40:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752177AbYK0MkW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 07:40:22 -0500
Received: from mail.bitdefender.com ([91.199.104.2]:53696 "EHLO
	mail.bitdefender.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045AbYK0MkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 07:40:21 -0500
From: Mihai =?utf-8?q?Don=C8=9Bu?= <mihai.dontu@gmail.com>
Organization: Home
To: Robert Hancock <hancockr@shaw.ca>
Subject: Re: ndiswrapper 1.54-2.6.27 released
Date: Thu, 27 Nov 2008 14:40:15 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <46697.166.70.238.44.1227679338.squirrel@webmail.wolfmountaingroup.com> <492DE3BD.9010802@shaw.ca>
In-Reply-To: <492DE3BD.9010802@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200811271440.15661.mihai.dontu@gmail.com>
X-BitDefender-Scanner: Clean, Agent: BitDefender qmail 3.0.0 on
 mail.bitdefender.com, sigver: 7.22124
X-BitDefender-Spam: No (7)
X-BitDefender-SpamStamp: v1, build 2.7.20.56845, bayes score: 500(0),
 pbayes score: 241(7), neunet score: 0(0), flags: [VALID_REPLY],
 total: 7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 November 2008, Robert Hancock wrote:
> jmerkey@wolfmountaingroup.com wrote:
> > ndiswrapper with the 2.6.27 breakage corrected.  The current maintainers
> > have not put out a release for 2.6.27 or later kernels, so I went ahead
> > and fixed it for 2.6.27.
> >
> > ftp://ftp.wolfmountaingroup.org/pub/ndiswrapper/ndiswrapper-1.54-2.6.27.7
> >.tar.gz
> >
> > Linux wireless drivers still do not work on most of my laptops and USB
> > wireless devices due to lack of firmware drivers and other problems with
> > native Linux wireless.  Anyone else with busted laptop wireless who need
> > ndiswrapper might as well be able to get it since the maintainers have
> > not posted recent releases for recent kernels.
>
> What devices are there left these days that are still not working with
> native drivers?

Broadcom Corporation BCM4312 802.11a/b/g (rev 01)

The driver works only if I don't subject it to high traffic. If I begin a 
large transfer (like a DVD ISO) the card looses the connection with the AP 
and behaves erratically in a way that interferes with my wireless mouse (I 
have to unplug the mouse receiver and plug it back in several times, which is 
very annoying).

-- 
Mihai Donțu
