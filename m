Return-Path: <linux-kernel-owner+w=401wt.eu-S932619AbXBSUX2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932619AbXBSUX2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 15:23:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932616AbXBSUX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 15:23:28 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:1558 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932615AbXBSUX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 15:23:27 -0500
Message-Id: <20070219201538.420238000@sirena.org.uk>
User-Agent: quilt/0.45-1
Date: Mon, 19 Feb 2007 20:15:38 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: Tim Hockin <thockin@hockin.org>, Jeff Garzik <jgarzik@pobox.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [patch 0/2] natsemi: Support Aculab E1/T1 cPCI carrier cards
X-Spam-Score: -3.7 (---)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

These patches add support for the Aculab E1/T1 cPCI carrier card to the
natsemi driver.  The first patch provides support for using the MII port
with no PHY and the second adds the quirks required to detect and
configure the card.

This revision should address the issues raised by Jeff over the weekend.
Apologies if I've missed anything.

--
"You grabbed my hand and we fell into it, like a daydream - or a fever."
