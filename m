Return-Path: <linux-kernel-owner+w=401wt.eu-S933574AbXBXWhu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933574AbXBXWhu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 17:37:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933572AbXBXWhu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 17:37:50 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:54083 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933574AbXBXWht (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 17:37:49 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: stable@kernel.org
Subject: Re: [PATCH] swsusp: Fix possible oops in userland interface
Date: Sat, 24 Feb 2007 23:30:49 +0100
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>, Stefan Seyfried <seife@suse.de>,
       Pavel Machek <pavel@ucw.cz>
References: <200702242306.44445.rjw@sisk.pl>
In-Reply-To: <200702242306.44445.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702242330.50633.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 24 February 2007 23:06, Rafael J. Wysocki wrote:
> From: Stefan Seyfried <seife@suse.de>
> 
> Fix the Oops occuring when SNAPSHOT_PMOPS or SNAPSHOT_S2RAM ioctl is called on
> a system without pm_ops defined (eg. a non-ACPI kernel on x86 PC).
> 
> Signed-off-by: Stefan Seyfried <seife@suse.de>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---

Sorry, I forgot to say: the patch is against 2.6.20 and for the 2.6.20.x stable
series.

Greetings,
Rafael
