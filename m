Return-Path: <linux-kernel-owner+w=401wt.eu-S1759673AbXKGXHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759673AbXKGXHk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 18:07:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759299AbXKGXHP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 18:07:15 -0500
Received: from mtl.rackplans.net ([69.90.0.18]:40831 "EHLO mtl.rackplans.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759262AbXKGXHN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 18:07:13 -0500
X-Greylist: delayed 1651 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Nov 2007 18:07:13 EST
Date: Wed, 7 Nov 2007 17:39:41 -0500 (EST)
From: Gerhard Mack <gmack@innerfire.net>
X-X-Sender: gmack@mtl.rackplans.net
To: linux-kernel@vger.kernel.org
Subject: 2.6.24-rc2 breaks nVidia MCP51 High Definition Audio 
Message-ID: <alpine.DEB.0.999.0711071737030.552@mtl.rackplans.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

hello,

This worked fine in 2.6.23 but now the kernel no longer sees my audio 
controller.

00:10.1 Audio device: nVidia Corporation MCP51 High Definition Audio (rev 
a2)
00:10.1 0403: 10de:026c (rev a2)

Let me know if I can provide more info or test patches.

	Gerhard

--
Gerhard Mack

gmack@innerfire.net

<>< As a computer I find your faith in technology amusing.
