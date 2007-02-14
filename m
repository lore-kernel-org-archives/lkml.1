Return-Path: <linux-kernel-owner+w=401wt.eu-S1751544AbXBNKis@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751544AbXBNKis (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 05:38:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751551AbXBNKis
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 05:38:48 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:4399 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553AbXBNKir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 05:38:47 -0500
X-Greylist: delayed 2126 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Feb 2007 05:38:47 EST
Message-Id: <20070214100203.413293000@sirena.org.uk>
User-Agent: quilt/0.45-1
Date: Wed, 14 Feb 2007 10:02:03 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: Tim Hockin <thockin@hockin.org>, Jeff Garzik <jgarzik@pobox.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 0/2] natsemi: Support Aculab E1/T1 cPCI carrier cards
X-Spam-Score: -3.7 (---)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

These patches add support for the Aculab E1/T1 cPCI carrier card to the
natsemi driver.  The first patch provides support for using the MII port
with no PHY and the second adds the quirk required to configure the
card.

--
"You grabbed my hand and we fell into it, like a daydream - or a fever."
