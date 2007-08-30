Return-Path: <linux-kernel-owner+w=401wt.eu-S1757314AbXH3DZw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757314AbXH3DZw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 23:25:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753902AbXH3DZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 23:25:44 -0400
Received: from mail.queued.net ([207.210.101.209]:4513 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751650AbXH3DZn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 23:25:43 -0400
Date: Wed, 29 Aug 2007 23:27:45 -0400
From: Andres Salomon <dilinger@queued.net>
To: jayakumar.alsa@gmail.com
Cc: akpm@linux-foundation.org, jordan.crouse@amd.com,
       linux-kernel@vger.kernel.org, info-linux@geode.amd.com
Subject: [PATCH 0/5] ALSA: cs5535audio fixes
Message-Id: <20070829232745.5ea9ff3e.dilinger@queued.net>
X-Mailer: Sylpheed 2.4.4 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here are a bunch of fixes for the cs5535audio driver.  None of these are
OLPC specific; generic chip and power management fixes, and one cleanup
patch.  All have been tested on an OLPC (5536), so even though the 5535
data sheet claims to be the same, it would be nice to hear success/failure
reports from someone with a 5535.

-- 
Andres Salomon <dilinger@queued.net>
