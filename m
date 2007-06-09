Return-Path: <linux-kernel-owner+w=401wt.eu-S1756197AbXFIQT2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197AbXFIQT2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 12:19:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755148AbXFIQTA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 12:19:00 -0400
Received: from emerald.lightlink.com ([205.232.34.14]:31802 "EHLO
	emerald.lightlink.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754589AbXFIQS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 12:18:59 -0400
X-Greylist: delayed 835 seconds by postgrey-1.27 at vger.kernel.org; Sat, 09 Jun 2007 12:18:59 EDT
Date: Sat, 9 Jun 2007 12:00:31 -0400
From: "Mark M. Hoffman" <mhoffman@lightlink.com>
To: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Jean Delvare <khali@linux-fr.org>, lm-sensors <lm-sensors@lm-sensors.org>
Subject: New hwmon maintainer
Message-ID: <20070609160031.GE3357@jupiter.solarsys.private>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew:

I am maintaining a git tree for the hwmon subsystem now.  You may pull from
it here:

	git://lm-sensors.org/kernel/mhoffman/hwmon-2.6.git testing

The current contents include the remainder of Jean Delvare's quilt patch
series, plus a single patch to MAINTAINERS.  Once you start pulling from
this git tree, Jean said he will delete his patch series entirely.

BTW: None of these patches are needed before 2.6.23.

Thanks & regards,

PS: Thanks for your good work and help, Jean.

-- 
Mark M. Hoffman
mhoffman@lightlink.com

