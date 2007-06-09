Return-Path: <linux-kernel-owner+w=401wt.eu-S1756843AbXFIQoq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756843AbXFIQoq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 12:44:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754925AbXFIQoi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 12:44:38 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55142 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755396AbXFIQoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 12:44:38 -0400
Date: Sat, 9 Jun 2007 09:43:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Mark M. Hoffman" <mhoffman@lightlink.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Jean Delvare <khali@linux-fr.org>,
       lm-sensors <lm-sensors@lm-sensors.org>
Subject: Re: New hwmon maintainer
Message-Id: <20070609094350.cdde52b3.akpm@linux-foundation.org>
In-Reply-To: <20070609160031.GE3357@jupiter.solarsys.private>
References: <20070609160031.GE3357@jupiter.solarsys.private>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Jun 2007 12:00:31 -0400 "Mark M. Hoffman" <mhoffman@lightlink.com> wrote:

> Hi Andrew:
> 
> I am maintaining a git tree for the hwmon subsystem now.  You may pull from
> it here:
> 
> 	git://lm-sensors.org/kernel/mhoffman/hwmon-2.6.git testing
> 
> The current contents include the remainder of Jean Delvare's quilt patch
> series, plus a single patch to MAINTAINERS.  Once you start pulling from
> this git tree, Jean said he will delete his patch series entirely.
> 
> BTW: None of these patches are needed before 2.6.23.
> 
> Thanks & regards,

np, thanks.

> PS: Thanks for your good work and help, Jean.

Yes, Jean's work is of high quality.

Please don't forget to alter ./MAINTAINERS.
