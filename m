Return-Path: <linux-kernel-owner+w=401wt.eu-S1753862AbYI2DxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862AbYI2DxR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 23:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751900AbYI2DxD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 23:53:03 -0400
Received: from linux-m68k.xs4all.nl ([82.95.193.92]:48219 "EHLO
	scrub.xs4all.nl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751171AbYI2DxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 23:53:03 -0400
X-Greylist: delayed 1449 seconds by postgrey-1.27 at vger.kernel.org; Sun, 28 Sep 2008 23:53:03 EDT
Message-Id: <20080929032709.693370201@linux-m68k.org>
User-Agent: quilt/0.46-1
Date: Mon, 29 Sep 2008 05:27:09 +0200
From: zippel@linux-m68k.org
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, sam@ravnborg.org
Subject: [PATCH 0/2] kconfig regression fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've sent these changes already some time ago, but I haven't heard
anything back, but they really should go into 2.6.27.
I only dropped the kbuild parts, silentoldconfig is now a little
misnamed, as oldconfig is now silent as well, but it still has a special
role within kbuild. The naming can still be changed later.

bye, Roman

-- 

