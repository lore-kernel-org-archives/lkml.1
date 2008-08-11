Return-Path: <linux-kernel-owner+w=401wt.eu-S1752001AbYHKIlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001AbYHKIlS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 04:41:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751301AbYHKIlE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 04:41:04 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:44414 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245AbYHKIlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 04:41:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=G0j/i8/MIvkS+mdM2BMW86kjtGxQNGEB7Z6cjbzYtC1qgyJEWMaFBauV1vUcnehjnT
         hEXk/iYm0bR6eRmxwCDj6bjDpwsj8BWojvGOLAsk4+b6pUY+yBwloNFpNFHkWpf14+zY
         IHJDRxF//K72gLBB1fjDwMqDseBJ4By6L0XpQ=
Message-ID: <3f9a31f40808110141y3d6da52cr86b85f29fce00add@mail.gmail.com>
Date: Mon, 11 Aug 2008 14:11:01 +0530
From: "Jaswinder Singh" <jaswinderlinux@gmail.com>
To: "Francois Romieu" <romieu@fr.zoreil.com>
Subject: Re: [Bug #11271] BUG: fealnx in 2.6.27-rc1
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>
In-Reply-To: <20080810130442.GA31367@electric-eye.fr.zoreil.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <VYYCiQF4qDI.A.BPH.KCjnIB@albercik>
	 <cX_-nNkxKaF.A.T-.DDjnIB@albercik>
	 <3f9a31f40808092327h272ba73emcfc1ead6b6d1099@mail.gmail.com>
	 <20080810130442.GA31367@electric-eye.fr.zoreil.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ueimor,

On Sun, Aug 10, 2008 at 6:34 PM, Francois Romieu <romieu@fr.zoreil.com> wrote:
> Jaswinder Singh <jaswinderlinux@gmail.com> :
> [...]
>> This still exists on 2.6.27-rc2 when I transfer some data on RealTek 8139C NIC.
>
> Does the transfer complete or not ?
>

I don't know. But I face lot of problems in web browsing, I need to
Refresh web browser many times :(

---[ end trace 1fefaa058f74f4aa ]---
NETDEV WATCHDOG: eth0 (fealnx): transmit timed out
eth0: Transmit timed out, status 00000110, resetting...
  Rx ring f7b46000:  80000000 80000000 80000000 80000000 80000000
80000000 80000000 80000000 80000000 80000000 80000000 80000000
  Tx ring f7b47000:  0000 0000 0000 80000000 0000 80000000
NETDEV WATCHDOG: eth0 (fealnx): transmit timed out
eth0: Transmit timed out, status 00000000, resetting...
  Rx ring f7b46000:  80000000 80000000 80000000 80000000 80000000
80000000 80000000 80000000 80000000 80000000 80000000 80000000
  Tx ring f7b47000:  0000 80000000 80000000 80000000 80000000 80000000
NETDEV WATCHDOG: eth0 (fealnx): transmit timed out
eth0: Transmit timed out, status 00000000, resetting...
  Rx ring f7b46000:  80000000 80000000 80000000 80000000 80000000
80000000 80000000 80000000 80000000 80000000 80000000 80000000
  Tx ring f7b47000:  0000 80000000 80000000 80000000 80000000 0000
NETDEV WATCHDOG: eth0 (fealnx): transmit timed out
eth0: Transmit timed out, status 00000000, resetting...
  Rx ring f7b46000:  80000000 80000000 80000000 80000000 80000000
80000000 80000000 80000000 80000000 80000000 80000000 80000000
  Tx ring f7b47000:  80000000 80000000 80000000 80000000 80000000 0000
NETDEV WATCHDOG: eth0 (fealnx): transmit timed out
eth0: Transmit timed out, status 00000000, resetting...
  Rx ring f7b46000:  80000000 80000000 80000000 80000000 80000000
80000000 80000000 80000000 80000000 80000000 80000000 80000000
  Tx ring f7b47000:  80000000 0000 80000000 80000000 80000000 80000000

Thank you,

Jaswinder Singh.
