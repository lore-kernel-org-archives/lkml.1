Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932354Ab0CMOyb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 09:54:31 -0500
Received: from mail-yw0-f198.google.com ([209.85.211.198]:48791 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754574Ab0CMOya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 09:54:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ApFUbJRo6eF8Om15pH1UeP/Meh1paqcYAvpF9EV1XrfNQ22LV7CQBL0o3aDJb7mqpr
         gk4LpOJp3eHLY/FeVk2KEGTbP3D1fpkgYXmTOAVSLxWvA4fCnpWEE4xf4wmKcmMtezpg
         Z8x+Zf3xLw1G2nL6KQObFHCcLaJ1TYmdyWoK4=
From: Jason Wong <tsanghan@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Staging: comedi drivers patches
Date: Sat, 13 Mar 2010 22:53:25 +0800
Message-Id: <1268492014-6355-1-git-send-email-tsanghan@gmail.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <Jason Wong <tsanghan@gmail.com>
References: <Jason Wong <tsanghan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is me stepinig up after watching a video on Greg KH's presentation in FOSDEM 2010.

All patches here correct brace coding style issue.

There are no dependency between the patches, excpet patch 8 and patch 9, which should be apply in correct order.

[PATCH 1/9] Staging: comedi: amplc_pci224: fixed multiple brace coding style issue
[PATCH 2/9] Staging: comedi: amplc_pci230: fix brace coding style issue
[PATCH 3/9] Staging: comedi: adl_pci9111: fixed multiple brace coding style issue
[PATCH 4/9] Staging: comedi: adl_pci9118: fixed multiple brace coding style issue
[PATCH 5/9] Staging: comedi: adv_pci1710: fixed multiple brace coding style issue
[PATCH 6/9] Staging: comedi: adv_pci_dio: fixed multiple brace coding style issue
[PATCH 7/9] Staging: comedi: cb_das16_cs: fixed multiple brace coding style issue
[PATCH 8/9] Staging: comedi: cb_pcidas64: fixed multiple brace coding style issue
[PATCH 9/9] Staging: comedi: cb_pcidas64: fixed a coding style missed in the previosu patch

Cheers

-Jason
