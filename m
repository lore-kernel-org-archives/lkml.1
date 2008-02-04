Return-Path: <linux-kernel-owner+w=401wt.eu-S1755912AbYBDQw2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912AbYBDQw2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 11:52:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751862AbYBDQwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 11:52:21 -0500
Received: from senator.holtmann.net ([87.106.208.187]:38778 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979AbYBDQwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 11:52:20 -0500
Subject: Re: Where to send new pcmcia driver?
From: Marcel Holtmann <marcel@holtmann.org>
To: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Cc: linux-pcmcia@lists.infradead.org,
       linux-main <linux-kernel@vger.kernel.org>
In-Reply-To: <20080204171100.e9aff4a5.Kristoffer.ericson@gmail.com>
References: <20080204171100.e9aff4a5.Kristoffer.ericson@gmail.com>
Content-Type: text/plain
Date: Mon, 04 Feb 2008 17:52:44 +0100
Message-Id: <1202143964.15090.69.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kristoffer,

> Im almost finished with my pcmcia driver for the h64461 chipset, it works fine just need to clean it up.
> 
> Now looking at the MAINTAINER list it doesn't reference anyone special as the maintainer for pcmcia subsystem.
> So in short where should I send the patch?
> 
> Also, I've tried on numerous occasions to seek help on pcmcia list and besides some helpful replies from Peter Stuge, it's been
> silent. Perhaps linux-pcmcia mailinglist would be better off getting merged into linux-main list?

post it to LKML for review.

Regards

Marcel


