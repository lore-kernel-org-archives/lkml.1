Return-Path: <linux-kernel-owner+w=401wt.eu-S1754446Ab0A0XFU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754446Ab0A0XFU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 18:05:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753177Ab0A0XFQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 18:05:16 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:34698 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753197Ab0A0XFO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 18:05:14 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 1/2] PM: really deprecate deprecated user ioctls
Date: Thu, 28 Jan 2010 00:05:50 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc5-rjw; KDE/4.3.5; x86_64; ; )
Cc: Jiri Slaby <jslaby@suse.cz>, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
References: <1264610778-13242-1-git-send-email-jslaby@suse.cz> <20100127194811.GB4626@elf.ucw.cz>
In-Reply-To: <20100127194811.GB4626@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001280005.50666.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 January 2010, Pavel Machek wrote:
> On Wed 2010-01-27 17:46:17, Jiri Slaby wrote:
> > They were deprecated and removed from exported headers more than 2
> > years ago. Inform users about their removal in the future now.
> > 
> > (Switch cases needed to be reorderded for an easy fall through.)
> > 
> > And add an entry to feature-removal-schedule.
> > 
> > Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> > Cc: Rafael J. Wysocki <rjw@sisk.pl>
> > Cc: Pavel Machek <pavel@ucw.cz>
> 
> ACK.

Applied.

Rafael
