Return-Path: <linux-kernel-owner+w=401wt.eu-S1753907AbYKATKw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907AbYKATKw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 15:10:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752396AbYKATKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 15:10:45 -0400
Received: from fmailhost03.isp.att.net ([204.127.217.103]:60197 "EHLO
	fmailhost03.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbYKATKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 15:10:44 -0400
X-Greylist: delayed 1526 seconds by postgrey-1.27 at vger.kernel.org; Sat, 01 Nov 2008 15:10:44 EDT
X-Originating-IP: [204.127.221.117]
From: f.duncan.m.haldane@att.net
To: linux-kernel@vger.kernel.org
Subject: [STAGING]: How does one set CONFIG_STAGING=y in 2.6.28-rc2 ?
Date: Sat, 01 Nov 2008 19:10:43 +0000
Message-Id: <110120081910.8202.490CA9B3000451E20000200A22228869349B0A02D29B9B0EBF0A020E0B040E08D203D2020E0C029A0BD200@att.net>
X-Mailer: AT&T Message Center Version 1 (Oct 30 2008)
X-Authenticated-Sender: Zi5kdW5jYW4ubS5oYWxkYW5lQGF0dC5uZXQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I want to experiment with the "staging" driver go7007 in 2.6.28-rc2 (try to build on ARM/orion_5x)

There seems no way to configure the build system to see the drivers in drivers/staging.
Is this a missing patch to kbuild, or have I missed something?

Thanks for any guidance.   There seems to be no doc on use of "staging" code.

