Return-Path: <linux-kernel-owner+w=401wt.eu-S1760708AbYFFQAU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760708AbYFFQAU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 12:00:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761387AbYFFPzh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 11:55:37 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:51823 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760281AbYFFPzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 11:55:31 -0400
Message-Id: <20080606155117.074799346@fluff.org.uk>
User-Agent: quilt/0.46-1
Date: Fri, 06 Jun 2008 16:51:17 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: linux-kernel@vger.kernel.org
Cc: Pierre Ossman <drzeus@drzeus.cx>, Harald Welte <laforge@openmoko.org>,
       Thomas Kleffel <tk@maintech.de>,
       Roman Moravcik <roman.moravcik@gmail.com>
Subject: [patch 00/15] S3C24XX SD/MMC driver series
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series provides support for the SD/MMC controller
contained in many of the Samsung SoCs. The patches have
been gathered from both the OpenMoko[1] kernel support
series (from various contributors) and my own updates
to update and add functionality.

I would like people to check over this series and ensure
that I have correctly attributed the patch source, and
to any objections to this seriese being submitted for
2.6.27. 

The series has been kept seperate due to the fact that
there are several contributors, including myself.

[1] http://www.openmoko.org/

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
