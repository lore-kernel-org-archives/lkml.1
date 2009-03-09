Return-Path: <linux-kernel-owner+w=401wt.eu-S1755754AbZCIWsh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755754AbZCIWsh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 18:48:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754700AbZCIWqD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 18:46:03 -0400
Received: from cmpxchg.org ([85.214.51.133]:60370 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755652AbZCIWqA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 18:46:00 -0400
Message-Id: <20090309223726.565021009@cmpxchg.org>
User-Agent: quilt/0.47-1
Date: Mon, 09 Mar 2009 23:37:26 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Oliver Neukum <oneukum@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: [patch 0/2] two hiddev fixes [-rc regressions]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

here are two patches for hiddev bugs that were introduced past .28.  I
think patch #2 fixes the 5th top bug on kerneloops.org for this
release cycle.  More details in the changelogs.

Well, no kerneloops link, the site just keeps time-outing on me...
It's the finish_wait() entry with 23 reports.

	Hannes

