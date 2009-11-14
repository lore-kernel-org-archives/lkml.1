Return-Path: <linux-kernel-owner+w=401wt.eu-S1755552AbZKNKaH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552AbZKNKaH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Nov 2009 05:30:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753587AbZKNKaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Nov 2009 05:30:07 -0500
Received: from senator.holtmann.net ([87.106.208.187]:58822 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346AbZKNKaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Nov 2009 05:30:06 -0500
Subject: Re: trying to add rfkill support to realtek driver for rtl8192e
From: Marcel Holtmann <marcel@holtmann.org>
To: saurav barik <saurav.barik@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <26b26d180911140116k370ee274l333e54858c66e3a1@mail.gmail.com>
References: <26b26d180911140116k370ee274l333e54858c66e3a1@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 14 Nov 2009 11:30:06 +0100
Message-ID: <1258194606.3299.23.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Saurav,

> I am trying to implement rfkill support for realtek driver for rtl8192e.
> The realtek driver we are using is very much similar to the one in
> kernel 2.6.31.5(linux-2.6.31.5/drivers/staging/rtl8192su).
> In order to use "wiphy_rfkill_set_hw_state", I need "struct wiphy"
> which in turn is a part of "ieee80211_hw" structure.
> However ieee80211_hw is not used in our driver.
> Is the usage of 80211_hw is obsolete?
> Without having the above structure how can I use the rfkill interface?
> 
> Anybody aware of this, please share some pointers.

you get more feedback if you ask this question on
linux-wireless@vger.kernel.org mailing list.

Regards

Marcel


