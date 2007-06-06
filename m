Return-Path: <linux-kernel-owner+w=401wt.eu-S1758764AbXFFRVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758764AbXFFRVV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 13:21:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754698AbXFFRVO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 13:21:14 -0400
Received: from mta-ps-be-02.sunrise.ch ([194.158.229.40]:38727 "EHLO
	mail-ps.sunrise.ch" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754678AbXFFRVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 13:21:13 -0400
X-Greylist: delayed 1383 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Jun 2007 13:21:13 EDT
From: Robin Farine <robin.farine@terminus.org>
To: Richard Purdie <rpurdie@rpsys.net>
Subject: [PATCH 0/2] generic LED driver
Date: Wed, 6 Jun 2007 18:57:50 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706061857.50961.robin.farine@terminus.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This generic LED driver implements the code common to all LED 
drivers while delegating actual LED accesses to platform supplied 
code. This allows exotic platforms to declare their LEDs in a few 
line of codes rather than reimplementing a complete LED driver.

I send it in two patches since you may want to apply the first 
trivial patch even if you do not consider the LED driver 
interesting enough for inclusion.

Regards,

Robin
