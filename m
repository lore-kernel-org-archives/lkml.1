Return-Path: <linux-kernel-owner+w=401wt.eu-S1754453AbXJ1VWb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754453AbXJ1VWb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 17:22:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751933AbXJ1VWV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 17:22:21 -0400
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:46301 "EHLO
	electric-eye.fr.zoreil.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750895AbXJ1VWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 17:22:20 -0400
Date: Sun, 28 Oct 2007 22:16:00 +0100
From: Francois Romieu <romieu@fr.zoreil.com>
To: "Sergey S. Kostyliov" <rathamahata@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Alexander Y. Fomichev" <gluk@php4.ru>
Subject: Re: 2.6.24-rc1 kills onboard r8169 (rtl8111b) NIC
Message-ID: <20071028211600.GA28735@electric-eye.fr.zoreil.com>
References: <d6a046090710281254k149e300alc66266f241ccdf03@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d6a046090710281254k149e300alc66266f241ccdf03@mail.gmail.com>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sergey S. Kostyliov <rathamahata@gmail.com> :
[...]
> After booting 2.6.24-rc1 on my home machine I lost onboard rtl8111b
> network card. It is neither functional nor even visible by lspci
> anymore.
> 
> Moreover rebooting to previous 2.6.23-rc9 didn't fix it - card was
> still not available.

It should reappear after some time at rest. Until I come with
something better, you should use 2.6.24-rc with the r8169 driver from
2.6.23.

-- 
Ueimor
