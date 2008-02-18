Return-Path: <linux-kernel-owner+w=401wt.eu-S1760796AbYBRTv7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760796AbYBRTv7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 14:51:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754267AbYBRTvs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 14:51:48 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44922 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752376AbYBRTvr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 14:51:47 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Subject: Re: keyboard dead with 45b5035
Date: Mon, 18 Feb 2008 20:50:01 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Laszlo Attila Toth <panther@balabit.hu>, netdev@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
References: <20080218185305.48a67587@mjolnir.drzeus.cx>
In-Reply-To: <20080218185305.48a67587@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802182050.01964.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 18 of February 2008, Pierre Ossman wrote:
> The patch "[RTNETLINK]: Send a single notification on device state changes." kills (at least)
> the keyboard here. Everything seems to work fine in single user mode, but when init starts
> spawning of logins, the keyboard goes bye-bye. Even the power button is ignored. :/ 

Please try with the patch from http://lkml.org/lkml/2008/2/18/331 .

Thanks,
Rafael
