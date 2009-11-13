Return-Path: <linux-kernel-owner+w=401wt.eu-S1756334AbZKMKm7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756334AbZKMKm7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 05:42:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932121AbZKMKmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 05:42:23 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50074 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756262AbZKMKmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 05:42:17 -0500
From: Luotao Fu <l.fu@pengutronix.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: spi-devel-general@lists.sourceforge.net,
       David Brownell <dbrownell@users.sourceforge.net>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: [V2] Patches for mpc52xx_spi
Date: Fri, 13 Nov 2009 11:41:14 +0100
Message-Id: <1258108877-25435-1-git-send-email-l.fu@pengutronix.de>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1257844329-20687-1-git-send-email-l.fu@pengutronix.de>
References: <1257844329-20687-1-git-send-email-l.fu@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: l.fu@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Grand,

here are the V2 of my patchset for mpc52xx_spi. Besides Wolframs suggestions I
also added some more fixes. Details of changes can be checked in the patch
header. Please do consider to apply the patches. The patch 1/2 e.g. fix bugs,
which prevent the driver to work in some cases, as seen on my board.

cheers
Luotao Fu
