Return-Path: <linux-kernel-owner+w=401wt.eu-S1757549AbZHGLYq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757549AbZHGLYq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 07:24:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757504AbZHGLYq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 07:24:46 -0400
Received: from cpsmtpm-eml101.kpnxchange.com ([195.121.3.5]:54123 "EHLO
	CPSMTPM-EML101.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752371AbZHGLYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 07:24:45 -0400
From: Frans Pop <elendil@planet.nl>
To: Chris Clayton <chris2553@googlemail.com>
Subject: Re: ath5k - strange regulatory domain change
Date: Fri, 7 Aug 2009 13:24:44 +0200
User-Agent: KMail/1.9.9
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
References: <c6b1100b0908070350t3101030bs4b3d2e7485ad9aee@mail.gmail.com>
In-reply-To: <c6b1100b0908070350t3101030bs4b3d2e7485ad9aee@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908071324.45269.elendil@planet.nl>
X-OriginalArrivalTime: 07 Aug 2009 11:24:45.0559 (UTC) FILETIME=[AA9B8870:01CA1751]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Clayton wrote:
> Because of some problems with my Belkin Wireless G card  (model
> F5D7010) and the rt61pci driver, I've started to use a "no-name" card
> that is supported by the ath5k driver.
> 
> A problem is that I have come across is that for some reason the CN
> regulatory domain is being set automatically. This doesn't happen with
> the Belkin (rt61) card. I have the following line in
> /etc/modprobe.d/modprobe.conf to set the regulatory domain to GB:
> 
> options cfg80211 ieee80211_regdom=GB

This issue has already been discussed extensively (after I reported it). 
Please see the following thread: http://lkml.org/lkml/2009/7/8/421. It 
contains a lot of information from the wireless maintainers.

Cheers.
FJP
