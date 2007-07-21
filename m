Return-Path: <linux-kernel-owner+w=401wt.eu-S1758692AbXGUWdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758692AbXGUWdT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 18:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751351AbXGUWdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 18:33:09 -0400
Received: from mu-out-0910.google.com ([209.85.134.185]:12389 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739AbXGUWdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 18:33:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=dcEwMcu7twjfq7TAxZzRyL3nK1K9l68Ao+gEd4blIMHlhxKjYuH5uLEylxM2l/RhXrfankpwomLXE7mIthKZt/WkFOGTLgf/7uheRtXzwSlReLoS3kzIisLEXtkskVnhl4bmGQx7uDDcw827ZEwv/vJiqVOLY3iybZU3AWjsyRk=
Message-ID: <46A28920.9060704@googlemail.com>
Date: Sun, 22 Jul 2007 00:30:56 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070721)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: mhoffman@lightlink.com, lm-sensors@lm-sensors.org
Subject: drivers/hwmon - 'defined but not used' warnings
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi ,

I noticed this warnings on current git:

...

drivers/hwmon/pc87360.c:1082: warning: 'pc87360_remove' defined but not used
drivers/hwmon/sis5595.c:580: warning: 'sis5595_remove' defined but not used
drivers/hwmon/smsc47m1.c:608: warning: 'smsc47m1_remove' defined but not used
drivers/hwmon/via686a.c:648: warning: 'via686a_remove' defined but not used
drivers/hwmon/vt8231.c:755: warning: 'vt8231_remove' defined but not used

...


Regards,

Gabriel C
