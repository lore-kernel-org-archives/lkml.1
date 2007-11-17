Return-Path: <linux-kernel-owner+w=401wt.eu-S1758898AbXKQLfg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758898AbXKQLfg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 06:35:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753880AbXKQLf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 06:35:28 -0500
Received: from b73.evanzo-server.de ([87.238.198.73]:42660 "EHLO
	s8073.evanzo-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816AbXKQLf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 06:35:27 -0500
X-Greylist: delayed 403 seconds by postgrey-1.27 at vger.kernel.org; Sat, 17 Nov 2007 06:35:27 EST
From: Tobias <kaminsky@finswimmer.de>
To: linux-kernel@vger.kernel.org
Subject: [REQUEST] Option for skipping unreadable blocks on Video DVD
Date: Sat, 17 Nov 2007 12:29:21 +0100
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711171229.22257.kaminsky@finswimmer.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

If you are accessing a scratched Video DVD and the device cannot read it, the 
process ends. 
What about a more tolerant way to handle unreadable blocks. 
Especially on Video DVDs single blocks are not that important than on data 
dvds.

So is there a way that the kernel tells the device to skip these bad blocks?

Tobias
