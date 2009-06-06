Return-Path: <linux-kernel-owner+w=401wt.eu-S1752777AbZFFJaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777AbZFFJaj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 05:30:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751740AbZFFJac
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 05:30:32 -0400
Received: from senator.holtmann.net ([87.106.208.187]:46488 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792AbZFFJac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 05:30:32 -0400
Subject: Re: Doubt regarding Wifi Driver iwlagn
From: Marcel Holtmann <holtmann@linux.intel.com>
To: Sivabalan Thirunavukkarasu <siva886@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <be4915c60906060136w6d052a9bq334faa585e097fa@mail.gmail.com>
References: <be4915c60906060136w6d052a9bq334faa585e097fa@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 06 Jun 2009 11:30:05 +0200
Message-Id: <1244280605.23850.75.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sivabalan,

>        I am using Ubuntu 9.04 64bit running its default kernel
> 2.6.28-11-generic. My doubt is regarding the wireless driver. The card
> my HP HDX16 laptop has is, ( from lspci )

please send such reports to linux-wireless@vger.kernel.org and not to
LKML since most of the wireless developers are not reading this mailing
list.

Also please have a try with Linus' 2.6.30-rc8 or wireless-testing kernel
or file a bug report against Ubuntu.

Regards

Marcel


