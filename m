Return-Path: <linux-kernel-owner+w=401wt.eu-S1755735AbYBIQX0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755735AbYBIQX0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 11:23:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753621AbYBIQXS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 11:23:18 -0500
Received: from data2.daybyday.de ([213.191.85.39]:45788 "EHLO
	data2.daybyday.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753485AbYBIQXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 11:23:17 -0500
X-Greylist: delayed 3605 seconds by postgrey-1.27 at vger.kernel.org; Sat, 09 Feb 2008 11:23:16 EST
From: Michael =?iso-8859-1?q?B=FCker?= <m.bueker@berlin.de>
To: linux-kernel@vger.kernel.org
Subject: Two comments on menuconfig usability
Date: Sat, 9 Feb 2008 16:23:06 +0100
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802091623.06504.m.bueker@berlin.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all, [please to CC me]

There's two things I want to comment on regarding menuconfig:

1) I know of the purpose of oldconfig, but I prefer using menuconfig for 
upgrading to newer kernel versions, because most of the time, I would select 
the standard options for new features anyway. menuconfig has the "(NEW)" 
string at the end of a feature's description. However, I find that hard to 
see among all the names of various lenghts. My proposal would be to have 
an "N" or a "NEW" appear to the _left_ of the selection boxes, so that, 
browsing through the menus, one could more easily spot the interesting 
places.

2) When selecting "Ralink driver support" (CONFIG_RT2X00), the accompanying 
drivers (CONFIG_RT2400PCI, CONFIG_RT61PC, ...) appear unindented. They should 
be indented by four spaces.

Cheers!
~Mik

-- 
Intrinsically unobtrusive antidisestablishmentarianistic
inclinations cause considerable psychotic devastation
among exasperated and marginally discomposed ornithologists.
