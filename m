Return-Path: <linux-kernel-owner+w=401wt.eu-S1755181AbXFKPUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181AbXFKPUl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 11:20:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752868AbXFKPUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 11:20:33 -0400
Received: from smtp-101-monday.nerim.net ([62.4.16.101]:50181 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752427AbXFKPUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 11:20:32 -0400
Date: Mon, 11 Jun 2007 17:22:11 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "Mark M. Hoffman" <mhoffman@lightlink.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       lm-sensors <lm-sensors@lm-sensors.org>
Subject: Re: New hwmon maintainer
Message-ID: <20070611172211.24d29a87@hyperion.delvare>
In-Reply-To: <20070609160031.GE3357@jupiter.solarsys.private>
References: <20070609160031.GE3357@jupiter.solarsys.private>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Jun 2007 12:00:31 -0400, Mark M. Hoffman wrote:
> I am maintaining a git tree for the hwmon subsystem now.  You may pull from
> it here:
> 
> 	git://lm-sensors.org/kernel/mhoffman/hwmon-2.6.git testing
> 
> The current contents include the remainder of Jean Delvare's quilt patch
> series, plus a single patch to MAINTAINERS.  Once you start pulling from
> this git tree, Jean said he will delete his patch series entirely.

Mark has my blessing, needless to say.
http://marc.info/?l=lm-sensors&m=117621009823952&w=2

> BTW: None of these patches are needed before 2.6.23.

Confirmed.

> PS: Thanks for your good work and help, Jean.

Well, thanks Mark for taking over :) I have no doubt you'll make good
work too.

-- 
Jean Delvare
