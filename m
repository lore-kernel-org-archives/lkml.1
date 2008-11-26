Return-Path: <linux-kernel-owner+w=401wt.eu-S1753260AbYKZGsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260AbYKZGsS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 01:48:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751272AbYKZGsJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 01:48:09 -0500
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:53410 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbYKZGsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 01:48:08 -0500
Message-ID: <46697.166.70.238.44.1227679338.squirrel@webmail.wolfmountaingroup.com>
Date: Tue, 25 Nov 2008 23:02:18 -0700 (MST)
Subject: ndiswrapper 1.54-2.6.27 released
From: jmerkey@wolfmountaingroup.com
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



ndiswrapper with the 2.6.27 breakage corrected.  The current maintainers
have not put out a release for 2.6.27 or later kernels, so I went ahead
and fixed it for 2.6.27.

ftp://ftp.wolfmountaingroup.org/pub/ndiswrapper/ndiswrapper-1.54-2.6.27.7.tar.gz

Linux wireless drivers still do not work on most of my laptops and USB
wireless devices due to lack of firmware drivers and other problems with
native Linux wireless.  Anyone else with busted laptop wireless who need
ndiswrapper might as well be able to get it since the maintainers have not
posted recent releases for recent kernels.


Jeff

