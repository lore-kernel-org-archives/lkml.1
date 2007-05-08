Return-Path: <linux-kernel-owner+w=401wt.eu-S934797AbXEHJWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934797AbXEHJWq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 05:22:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934617AbXEHJWq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 05:22:46 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:51685 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934616AbXEHJWp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 05:22:45 -0400
Date: Tue, 8 May 2007 11:21:44 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: "Robert P. J. Day" <rpjday@mindspring.com>
cc: Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][RFC] Create a top-level "Space-critical features" menu.
In-Reply-To: <Pine.LNX.4.64.0705080431110.13403@localhost.localdomain>
Message-ID: <Pine.LNX.4.61.0705081117051.17280@yvahk01.tjqt.qr>
References: <Pine.LNX.4.64.0705080356020.10881@localhost.localdomain>
 <1178612519.3042.294.camel@localhost.localdomain>
 <Pine.LNX.4.64.0705080431110.13403@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 8 2007 04:41, Robert P. J. Day wrote:
>
>  in my opinion, the config option "EMBEDDED" is just plain silly.  as
>i mentioned earlier, there may be other reasons that people want to
>de-activate normally selected features rather than just for strictly
>embedded systems.

Did not you want to make a patch row that expresses all your ideas, aka
  CONFIG_EXPERT
  CONFIG_ASKFORDETAILS (former CONFIG_EMBEDDED, e.g. "place in memory where
kernel is loaded")
  CONFIG_OBSOLETE
  CONFIG_DEPRECATED
etc.? :)



Jan
-- 
